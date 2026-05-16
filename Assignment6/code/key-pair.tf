resource "aws_key_pair" "deployer" {
  key_name   = "cs316-assignment4-key" # Exact assignment name
  public_key = file("/home/muhammad_ahmad/.ssh/ec2_terraform.pub") # Full path
}