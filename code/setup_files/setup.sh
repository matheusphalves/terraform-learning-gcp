#!/bin/bash

# Stops the script execution if at least one command fails
set -e  

BUCKET_NAME="${1:-marketplace_bucket_app}"
JAR_NAME="${2:-marketplace_app.jar}"
APP_NAME="${3:-marketplace}"
APP_DIR="/opt/$APP_NAME"
APP_PORT="${4:-8089}"
NGINX_CONF="${5:-/etc/nginx/sites-available/default}"


check_args() {
    local expected="$1"
    shift
    local actual="$#"
    
    if [ "$actual" -ne "$expected" ]; then
        echo "Usage: ${FUNCNAME[1]} <args...>"
        echo "Expected $expected arguments, but got $actual."
        return 1
    fi
}

# Installs the Nginx e OpenJDK 17 JRE
function install_required_dependencies {
    echo "[$0] Updating packages and installing Nginx and OpenJDK 17 JRE..."
    sudo apt-get update &&
     sudo apt install -y nginx openjdk-17-jre
}

# Download the file from Google Cloud Storage Bucket
function download_file_from_bucket {
    
    check_args 2 "$@"
    
    local FILE_NAME="$1"
    local BUCKET_NAME="$2"
    
    echo "[$0] Downloading JAR file ($FILE_NAME) from bucket ($BUCKET_NAME)..."
    gsutil cp gs://$BUCKET_NAME/$FILE_NAME .

    if [ ! -f "$JAR_NAME" ]; then
        echo "[$0] Failed to download: '$FILE_NAME'."
        exit 1
    fi
}

# Install the jar and setup their service on systemd
function install_jar_and_setup_service {

    check_args 3 "$@"

    local APP_NAME="$1"
    local JAR_NAME="$2"
    local APP_DIR="$3"

    echo "[$0] Installing $JAR_NAME at $APP_DIR"
    sudo mkdir -p $APP_DIR

    if [ -f "$APP_DIR/$JAR_NAME" ]; then
        echo "[$0] Removing old JAR file..."
        sudo rm "$APP_DIR/$JAR_NAME"
    fi

    sudo cp "$JAR_NAME" "$APP_DIR"

    echo "[$0] Creating service file at /etc/systemd/system/$APP_NAME.service..."
    cat <<EOF | sudo tee /etc/systemd/system/$APP_NAME.service
    [Unit]
    Description=$APP_NAME Service
    After=network.target

    [Service]
    ExecStart=/usr/bin/java -jar $APP_DIR/$JAR_NAME --spring.profiles.active=gcp-dev
    User=www-data
    Restart=always

    [Install]
    WantedBy=multi-user.target
EOF

    echo "[$0] Updating daemon and starting the service..."
    sudo systemctl daemon-reload
    sudo systemctl start "$APP_NAME".service
    sudo systemctl enable "$APP_NAME".service
}



# Update Nginx configuration to foward request to the specified application port
function update_nginx_configuration {

    check_args 2 "$@"

    local NGINX_CONF="$1"
    local APP_PORT="$2"

    echo "[$0] Backing up the original Nginx configuration..."
    sudo cp $NGINX_CONF ${NGINX_CONF}.bak

    sudo tee $NGINX_CONF <<EOF
    server {
        listen 80 default_server;
        listen [::]:80 default_server;

        root /var/www/html;

        server_name _;

        location / {
            proxy_pass http://localhost:$APP_PORT;
            proxy_set_header Host \$host;
            proxy_set_header X-Real-IP \$remote_addr;
            proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        }
    }
EOF

    echo "[$0] Restart Nginx to apply the configuration..."
    sudo systemctl restart nginx
}

function execute {
    install_required_dependencies
    download_file_from_bucket "$JAR_NAME" "$BUCKET_NAME"
    install_jar_and_setup_service "$APP_NAME" "$JAR_NAME" "$APP_DIR"
    update_nginx_configuration "$NGINX_CONF" "$APP_PORT"
    echo "[$0] The instalation script has been completed."
}

execute
