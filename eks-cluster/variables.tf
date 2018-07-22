variable "vpc_id" {
 description = "vpc id"
}

variable "public_subnet" {
 description = "public subnet"
 default     = []
}

variable "private_subnet" {
 description = "private subnet"
 default     = []
}

variable "cluster-name" {
    description = "cluster name"
}
variable "node-security-id" {
    description = "node security"
}
variable "workstation-external-cidr"{ 
    description = "workstation external cidr"
}