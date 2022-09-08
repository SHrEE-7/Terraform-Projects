provider "aws" {
  region = "ap-south-1"
}

resource "aws_iam_user" "my_iam_user" {
  count = 1
  name  = "my_iam_user_${count.index}"
}
