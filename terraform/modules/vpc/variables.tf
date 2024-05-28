variable "availability_zone_1" {
  description = "The AZ 1"
  type        = string
}

variable "availability_zone_2" {
  description = "The AZ 2"
  type        = string
}

variable "cidr_public_1" {
  description = "CIDR for Public subnet in AZ 1"
  type        = string
  default = "10.0.1.0/24"
}

variable "cidr_public_2" {
  description = "CIDR for Public subnet in AZ2"
  type        = string
    default = "10.0.2.0/24"
}


variable "cidr_private_1" {
  description = "CIDR for Private subnet in AZ 1"
  type        = string
    default = "10.0.3.0/24"
}

variable "cidr_private_2" {
  description = "CIDR for Private subnet in AZ 2"
  type        = string
    default = "10.0.4.0/24"
}

variable "cidr_db_1" {
  description = "CIDR for DB subnet in AZ 1"
  type        = string
    default = "10.0.5.0/24"
}

variable "cidr_db_2" {
  description = "CIDR for DB subnet in AZ 2"
  type        = string
    default = "10.0.6.0/24"
}

variable "cidr_vpc" {
  description = "CIDR for DB subnet in AZ 2"
  type        = string
  default = "10.0.0.0/16"
}