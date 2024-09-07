variable "aws_region" {
  description = "AWS region to use for resource"
  type        = string
  default     =  "eu-west-2"
}
 
variable "aws_access_key" {
  description = "Authentication key for aws"
  type        = string
  sensitive   = true
}
 
 
variable "aws_secret_key" {
  description = "Authentication key for aws"
  type        = string
  sensitive   = true
}
 
variable "aws_instance_type" {
  description = "aws region to use for resource"
  type        = map(string)
  default     = {
    small     = "t2.small"
    medium    =  "t2.medium"
    large     =  "t2.large"
  }
 
 
}

/*variable "aws_ec2_instance_type" {
  description = "aws region to use for resource"
  type        = string
  default     = "t2.micro"
}*/


 
variable "vpc_cidr_block" {
  description = "CIDR block for VPC"
  type        = string
  default     = "0.0.0.0/0"
}
 
variable "instance_count" {
  default = "3"
}
 
/*variable "aws_network_interface" {
  description = "creating static private ip address"
  type = list(string)
  default = ["172.20.16.10", "172.20.16.20", "172.20.16.30"]*/