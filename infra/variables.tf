variable "region" {
  description = "Domyślny region dla zasobów Google Cloud."
  type        = string
  default     = "europe-west3"
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
  nullable    = false

  validation {
    condition     = length(trimspace(var.image)) > 0
    error_message = "Podaj niepusty adres obrazu przez TF_VAR_image lub lokalny plik tfvars."
  }
}
