# Proxmox Variables
variable "proxmox_api_url" {
  type    = string
  default = ""
}

variable "proxmox_api_token_id" {
  type    = string
  default = ""
}

variable "proxmox_api_token_secret" {
  type      = string
  default   = ""
  sensitive = true
}

variable "proxmox_node" {
  type    = string
  default = "pve"
}

variable "ssh_username" {
  type    = string
  default = "root"
}

variable "ssh_key" {
  type      = string
  default   = ""
  sensitive = true
}

// versioning
variable "ctrd_version" {
  type    = string
  default = "1.6.*"
}
variable "kube_version" {
  type    = string
  default = "1.26.*"
}