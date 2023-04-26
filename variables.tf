variable "instance_data" {
  type = list(object({
    instance_id      = string
    ami_id           = string
    instance_type    = string
    name             = string
  }))

  default = [
    {
      instance_id      = "i-0fae66b6348bdb0a2"
      ami_id           = "ami-02396cdd13e9a1257"
      instance_type    = "t2.micro"
      name             = "my_ec2_new"
    },
    {
      instance_id      = "i-0410e332568b4595d"
      ami_id           = "ami-02396cdd13e9a1257"
      instance_type    = "t3.small"
      name             = "my_ec2_new2"
    }
  ] 
} 