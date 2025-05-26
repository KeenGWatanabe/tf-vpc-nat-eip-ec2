variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "ce-grp-4"  # Default value (override when needed)
}

variable "aws_key_pair" {
  description = "keypair name for instance"
  type = string
  sensitive = true
}
variable "my_ip" {
  description = "Your IP address"
  type = string
  sensitive = true
}


variable "settings" {
  description = "Configuration settings"
  type = map(any)
  default = {
    "web_app" = {
      count         = 1
      instance_type = "t2.micro"
    }
  }
}