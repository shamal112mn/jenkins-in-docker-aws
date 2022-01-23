variable "ami" { default = "ami-04505e74c0741db8d" }
# us-east-2 ubuntu20.04 ami-0fb653ca2d3203ac1
#  us-east-1 ubuntu20.04 ami-04505e74c0741db8d
variable "region" { default = "us-east-1" }
variable "mysystem" { default = "98.46.118.239/32" }
variable "instance_type" { default = "t2.micro" }
variable "profile" {
  type        = string
  description = " Set user with export TF_VAR_profile='user_profile' "
}

