resource "aws_cloud9_environment_ec2" "handson" {
  instance_type = "t2.micro"
  name = "yamasaki-20240704"
  image_id      = "amazonlinux-2-x86_64"
}
