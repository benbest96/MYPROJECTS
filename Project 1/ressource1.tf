provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/Users/MaBP/.aws/credentials"
}

resource "aws_instance" "UdacityT2" {
  ami           = "ami-07c1207a9d40bc3bd"
  count         = "4"
  instance_type = "t2.micro"
  subnet_id     = "subnet-623ad209"
  tags = {
    Name = "ress T2"
  }
}

# resource "aws_instance" "UdacityM4" {
#   ami           = "ami-07c1207a9d40bc3bd"
#   count         = "2"
#   instance_type = "m4.large"
#   subnet_id     = "subnet-623ad209"
#   tags = {
#     Name = "ress M4"
#   }
# }