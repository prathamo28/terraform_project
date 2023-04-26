resource "aws_instance" "example_instance" {
  count = length(var.instance_data)

  ami           = var.instance_data[count.index].ami_id
  instance_type = var.instance_data[count.index].instance_type
  # other required parameters

  tags = {
    Name = var.instance_data[count.index].name
  }
}

