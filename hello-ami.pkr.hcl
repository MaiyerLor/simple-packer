packer {
  required_plugins {
    amazon = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "hello" {
  region        = "us-east-2"
  instance_type = "t2.micro"

  # Use your provided Ubuntu AMI
  source_ami    = "ami-0198cdf7458a7a932"

  ami_name      = "packer-hello-{{timestamp}}"
  ssh_username  = "ubuntu"

  # Tags for the AMI - this will make it show with a name in AWS console
  tags = {
    Name        = "Hello Packer AMI"
    CreatedBy   = "Packer"
    CreatedOn   = "{{timestamp}}"
  }
}

build {
  sources = ["source.amazon-ebs.hello"]

  # Write a hello.sh script to the AMI
  provisioner "file" {
    content = <<-EOT
      #!/bin/bash
      echo "Hello from Packer AMI based on ami-01abb3b5c93add95c!"
    EOT
    destination = "/home/ubuntu/hello.sh"
  }

  # Make the script executable
  provisioner "shell" {
    inline = [
      "chmod +x /home/ubuntu/hello.sh"
    ]
  }
}

