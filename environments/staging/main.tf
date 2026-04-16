provider "aws" {
  region = "ap-south-1"
}

module "ec2" {
  source        = "../../modules/ec2"
  instance_type = "t3.micro"
  env           = "staging"
  name          = "staging-web-server"
  key_name      = "staging-web-server-instance" # REPLACE with your actual key pair name
}


output "public_ip" {
  value = module.ec2.public_ip
}
