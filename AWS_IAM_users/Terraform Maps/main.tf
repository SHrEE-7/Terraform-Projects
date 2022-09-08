variable "users" {
  default = {
    Eric : { country : "India", department : "CSE" }
    John : { country : "India", department : "ETC" }
    Krish : { country : "India", department : "ETRX" }
  }
}

provider "aws" {
  region = "ap-south-1"
}
resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name     = each.key
  tags = {
    country : each.value.country
  department : each.value.department }
}
