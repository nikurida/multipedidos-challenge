resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Allow Lambda function to access the internet"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "lambda_sg"
  }
}