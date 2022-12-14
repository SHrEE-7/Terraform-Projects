variable "iam_user_name_prefix" {
  type = string #any, number, bool, set, list, object, tuple, map   
  default = "my_iam_user"
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "my_iam_user" {
  count = 1
  name  = "${var.iam_user_name_prefix}${count.index}"
}
