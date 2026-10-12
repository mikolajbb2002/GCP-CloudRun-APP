variable "cluster_name" {
  type = string
}

variable "network_id" {
  description = "ID VPC dla klastra GKE."
  type        = string
}

variable "subnet_id" {
  description = "ID podsieci z dodatkowymi zakresami pods i services."
  type        = string
}

variable "region" {
  type    = string
  default = "europe-west3"
}

variable "project_id" {
  type = string

}

variable "account_id" {
  type = string
}

variable "secret_id" {
  type = string
}
