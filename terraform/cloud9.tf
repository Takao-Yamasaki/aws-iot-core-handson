resource "aws_cloud9_environment_ec2" "handson" {
  instance_type = "t2.micro"
  name = local.project
  image_id      = "amazonlinux-2-x86_64"
  automatic_stop_time_minutes = "60"
}
