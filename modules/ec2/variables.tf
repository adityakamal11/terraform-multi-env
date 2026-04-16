variable "instance_type" {
  description = "The type of instance to start"
  type        = string
}

variable "env" {
  description = "The environment name"
  type        = string
}

variable "name" {
  description = "The name for the instance"
  type        = string
  default     = "web-server"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for the instance"
  type        = string
}

