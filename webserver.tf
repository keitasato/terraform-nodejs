# Key pair
resource "aws_key_pair" "keypair" {
  key_name   = "${var.project}-${var.environment}-keypair"
  public_key = file("./kekkepy-keypair.pub")

  tags = {
    Name    = "${var.project}-${var.environment}-web-sg"
    Project = "${var.project}"
    Env     = "${var.environment}"
  }
}

#Web server
resource "aws_instance" "web_server" {
  ami                         = "ami-0cfc97bf81f2eadc4"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = aws_key_pair.keypair.key_name

  tags = {
    Name    = "${var.project}-${var.environment}-webserver"
    Project = "${var.project}"
    Env     = "${var.environment}"
    Type    = "app"
  }

  user_data = <<EOF
#!/bin/bash
sudo yum update -y
sudo yumm install -y curl
curl -sL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs
npm install -g @vue/cli
EOF
}