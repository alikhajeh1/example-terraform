

resource "aws_instance" "web_app2" {
  ami           = "ami-674cbc1e"
  instance_type = "m3.xlarge"

  tags = {
    Environment = "production"
    Service = "web-app"
  }

  root_block_device {
    volume_size = 50
  }
}
