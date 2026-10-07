variable "region" {
  description = "Domyślny region dla zasobów Google Cloud."
  type        = string
  default     = "europe-west3"
}

variable "registry_repo_id" {
  type = string
}

variable "registry_repo_description" {
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
  description = "Dedykowany zakres /28 connectora, bez nakładania się na podsieci."
  type        = string
}

variable "router_name" {
  type = string
}

variable "nat_name" {
  type = string
}

variable "cloud_service_name" {
  type = string
}

variable "image" {
  description = "Pełny adres istniejącego obrazu kontenera wraz z tagiem lub digestem."
  type        = string
}
