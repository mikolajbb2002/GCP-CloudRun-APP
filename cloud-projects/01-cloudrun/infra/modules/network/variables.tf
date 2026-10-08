variable "region" {
  type    = string
  default = "europe-west3"
}

variable "project_id" {
  type = string

}

variable "vpc_name" {
  type = string
}

variable "subnet_01_name" {
  type = string
}

variable "subnet_01_cidr" {
  type = string
}

variable "subnet_02_name" {
  type = string
}

variable "subnet_02_cidr" {
  type = string
}

variable "vpc_connector_name" {
  type = string
}

variable "connector_cidr" {
  type = string
}

variable "router_name" {
  type = string
}

variable "nat_name" {
  type = string
}

