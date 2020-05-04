variable "location" {
  description = "The location/region where the demo resources are to be created."
  default     = "centralus"
}

variable "vnet-space" {
  description = "Address Space for VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}


variable "subnet-list" {
  description = "List of subnets for VNet"
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet-names-list" {
  description = "List of names of subnets for VNet"
  type        = list(string)
  default = [
    "subnet-web",
    "subnet-app",
    "subnet-db"
  ]
}


variable "vm-username" {
  default = "mrhoads"
}

variable "allowed-source-ssh" {
  description = "Allowed source IP range for SSH access"
}

variable "tagPurpose" {
  description = "purpose of VM"
  default = "demo"
}

variable "tagKeepUntil" {
  description = "keepUntil date for tagging purposes"
  default     = "20200506"
}