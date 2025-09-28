# Simple Packer AMI Example

This is a simple example demonstrating how to create a custom Amazon Machine Image (AMI) using HashiCorp Packer.

## What This Does

This Packer configuration creates a custom AMI based on Ubuntu that includes:
- A simple "Hello World" script at `/home/ubuntu/hello.sh`
- Proper tagging so the AMI appears with a readable name in the AWS console
- Basic provisioning to make the script executable

## Prerequisites

1. **Packer installed**: Download from [packer.io](https://www.packer.io/downloads)
2. **AWS CLI configured** with appropriate credentials and permissions
3. **AWS permissions** to create EC2 instances, AMIs, and associated resources

### Required AWS Permissions

Your AWS credentials need the following permissions:
- `ec2:RunInstances`
- `ec2:TerminateInstances`
- `ec2:CreateImage`
- `ec2:DescribeImages`
- `ec2:DescribeInstances`
- `ec2:CreateTags`
- `ec2:DescribeSnapshots`
- `ec2:CreateSnapshot`

## Files

- `hello-ami.pkr.hcl` - Main Packer configuration file
- `README.md` - This documentation

## Configuration Details

### Source AMI
- **Base Image**: `ami-01abb3b5c93add95c` (Ubuntu)
- **Region**: `us-east-1`
- **Instance Type**: `t2.micro` (free tier eligible)

### Output AMI
- **Name**: `packer-hello-{{timestamp}}` (automatically timestamped)
- **Display Name**: "Hello Packer AMI" (appears in AWS console)
- **SSH User**: `ubuntu`

### What Gets Installed
1. A shell script at `/home/ubuntu/hello.sh` that prints a hello message
2. The script is made executable with proper permissions

## Usage

### 1. Initialize Packer
First, initialize Packer to download required plugins:
```bash
packer init hello-ami.pkr.hcl
```

### 2. Validate Configuration
Verify your configuration is correct:
```bash
packer validate hello-ami.pkr.hcl
```

### 3. Build the AMI
Create the AMI:
```bash
packer build hello-ami.pkr.hcl
```

### 4. Find Your AMI
After the build completes:
- Go to the AWS EC2 Console
- Navigate to "AMIs" under "Images"
- Look for "Hello Packer AMI" in the list
- Note the AMI ID for launching instances

## Testing Your AMI

Once your AMI is created, you can test it by:

1. **Launch an EC2 instance** using your new AMI
2. **SSH into the instance**:
   ```bash
   ssh -i your-key.pem ubuntu@your-instance-ip
   ```
3. **Run the hello script**:
   ```bash
   ./hello.sh
   ```
   You should see: `Hello from Packer AMI based on ami-01abb3b5c93add95c!`

## Customization Ideas

You can extend this example by:

### Adding More Software
```hcl
provisioner "shell" {
  inline = [
    "sudo apt-get update",
    "sudo apt-get install -y nginx",
    "sudo systemctl enable nginx"
  ]
}
```

### Installing from Files
```hcl
provisioner "file" {
  source      = "my-app.tar.gz"
  destination = "/tmp/my-app.tar.gz"
}
```

### Using Variables
```hcl
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

### Different Base Images
- Amazon Linux 2: `ami-0abcdef1234567890`
- CentOS: `ami-0987654321abcdef0`
- Windows: `ami-0123456789abcdef0`

## Troubleshooting

### Common Issues

**Permission Denied**
- Ensure AWS credentials are configured: `aws configure`
- Verify IAM permissions include EC2 and AMI creation rights

**Build Fails**
- Check the Packer logs for specific error messages
- Verify the source AMI ID is correct for your region
- Ensure security groups allow SSH access (port 22)

**AMI Not Found in Console**
- Check you're looking in the correct AWS region
- Verify the build completed successfully
- Look for AMIs with "Hello Packer AMI" name tag

### Debug Mode
Run with debug output:
```bash
PACKER_LOG=1 packer build hello-ami.pkr.hcl
```

## Cost Considerations

- Building AMIs incurs charges for the EC2 instance time (usually minutes)
- AMI storage has ongoing costs (~$0.05/GB-month)
- Delete unused AMIs to avoid storage costs

## Best Practices

1. **Use specific source AMI IDs** rather than latest
2. **Tag your AMIs** with meaningful metadata
3. **Test AMIs** before using in production
4. **Clean up old AMIs** regularly
5. **Use variables** for reusable configurations
6. **Version your AMIs** with descriptive names

## Next Steps

- Try building with different base images
- Add more complex provisioning (Docker, applications, etc.)
- Implement AMI versioning strategies
- Integrate with CI/CD pipelines
- Explore Packer's other builders (Docker, VirtualBox, etc.)

## Resources

- [Packer Documentation](https://www.packer.io/docs)
- [AWS AMI Documentation](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)
- [Packer Amazon EBS Builder](https://www.packer.io/plugins/builders/amazon/ebs)
