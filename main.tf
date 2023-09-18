provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

resource "aws_instance" "web_app" {
  ami           = "ami-674cbc1e"
  instance_type = "m5.8xlarge"             # <<<<< Try changing this to m5.8xlarge to compare the costs

  tags = {
    Environment = "prod"
    Service = "web-app"
  }

  root_block_device {
    volume_size = 10
  }

  ebs_block_device {
    device_name = "my_data"
    volume_type = "io1"                     # <<<<< Try changing this to gp2 to compare costs
    volume_size = 12000
    iops        = 1500
  }
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello_world"
  filename      = "test"
  role          = "arn:aws:lambda:us-east-1:account-id:resource-id"
  handler       = "exports.test"
  runtime       = "nodejs12.x"
  memory_size   = 512                      # <<<<< Try changing this to 512 to compare costs

  tags = {
    Service = "web-app"
  }
}
