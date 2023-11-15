locals {
  vpn-ip = <<EOF
{${var.ip}}
EOF
  default_tags = {
    Environment = "development"
    Managed     = "terraform"
  }
}
