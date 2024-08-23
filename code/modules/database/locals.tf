locals {
  db_password = random_password.user.result
}

locals {
  db_username = random_string.db_username.result
}