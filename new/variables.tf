
/*=== VARIABLES ===*/

variable "region" {
  type = string
  description = "AWS region to launch resources."
  default = "us-east-1"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "example-vpc"
}

variable "cidr_block" {
  type = string
  description = "CIDR for vpc"
  default = "10.0.0.0/16"
}

variable "private_subnet" {
type        = string
description = "List of private subnets to create within the VPC"
default     = "10.0.1.0/24"

variable "subnet_count" {
  type        = string
  description = "Subnet Count"
  default     = 1
}

/*=== Enable Private subnet along with Public subnet on a single AZ. ===*/
variable "enable_private_subnet" {
  type = bool
  description = "Option to enable private subnet"
  default = true
}

