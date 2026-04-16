resource "aws_security_group" "web" {
  name        = "${var.name}-sg"
  description = "Allow HTTP and SSH traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-07216ac99dc46a187"
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.web.id]
  key_name                    = var.key_name
  user_data_replace_on_change = true

  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    set -e
    set -x
    # Redirect all output to log
    exec > /var/log/user_data.log 2>&1
    echo "=== Starting setup at $(date) ==="
    # Wait for apt to be available
    while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
      echo "Waiting for dpkg lock..."
      sleep 5
    done
    apt-get update
    apt-get install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo '<h1>Hello from Terraform in ${var.env}</h1>' > /var/www/html/index.html
    echo "=== Setup complete at $(date) ==="
    EOF

  tags = {
    Name = "${var.name}-instance"
    Env  = var.env
  }
}
