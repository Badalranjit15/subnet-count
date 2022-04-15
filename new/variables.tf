
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

variable "aws_vpc" {
  type = map(string)
  description = "CIDR for vpc"
  default = {
    cidr_block                       = "10.0.0.0/16"
    enable_dns_hostnames             = false
    enable_dns_support               = false
  }
}

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

