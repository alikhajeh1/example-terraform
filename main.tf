provider "aws" {
  region                      = "us-east-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  access_key                  = "mock_access_key"
  secret_key                  = "mock_secret_key"
}

resource "aws_instance" "web_app" {
  ami           = "ami-674cbc1e"
  instance_type = "m5.xlarge"              # <<<<< Try changing this to m5.8xlarge to compare the costs

  tags = {
    Environment = "production"
    Service = "web-app"
  }

  root_block_device {
    volume_size = 50
  }

  ebs_block_device {
    device_name = "my_data"
    volume_type = "io1"                     # <<<<< Try changing this to gp2 to compare costs
    volume_size = 500
    iops        = 800
  }
}

resource "aws_lambda_function" "hello_world" {
  function_name = "hello_world"
  role          = "arn:aws:lambda:us-east-1:012345678912:resource-id"
  handler       = "exports.test"
  runtime       = "nodejs12.x"
  filename      = "myfunction.js"
  memory_size   = 1024                      # <<<<< Try changing this to 512 to compare costs

  tags = {
    Environment = "Prod"
    Service = "api"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket"
}

resource "aws_s3_bucket_lifecycle_configuration" "bucket-config" {
  bucket = aws_s3_bucket.example.id

  rule {
    id = "log"

    expiration {
      days = 30
    }
  }
}

resource "aws_launch_template" "foobar" {
  name_prefix   = "foobar"
  image_id      = "ami-1a2b3c"
  instance_type = "t2.micro"
}

resource "aws_autoscaling_group" "bar" {
  availability_zones = ["us-east-1a"]
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1
  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.foobar.id
      }

      override {
        instance_requirements {
          memory_mib {
            min = 8192M
            max = 32768M
          }
          vcpu_count {
            min = 4
            max = 32
          }
          instance_generations = ["current"]
        }
      }
    }
  }
}
