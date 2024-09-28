# RSA key of size 4096 bits
resource "tls_private_key" "keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

//Creating private key
resource "local_file" "keypair" {
    content = tls_private_key.keypair.private_key_pem
    filename =  "jenkins-key.pem"
    file_permission = "600"
}

//create my public key on aws
resource "aws_key_pair" "keypair" {
    key_name = "jenkins-key"
    public_key = tls_private_key.keypair.public_key_openssh  
}

//create maven instance
resource "aws_instance" "maven" {
  ami           = "ami-0aa8fc2422063977a"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = aws_key_pair.keypair.id 
  vpc_security_group_ids =  [aws_security_group.maven_sg.id]
  user_data = file(("./userdata1.sh"))
  

  tags = {
    Name = "maven-server"
  }
}

//create jenkins instance  
resource "aws_instance" "jenkins" {
  ami           = "ami-0aa8fc2422063977a"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = aws_key_pair.keypair.id 
  vpc_security_group_ids =  [aws_security_group.jenkins_sg.id ]
  user_data = file(("./userdata3.sh"))
  

  tags = {
    Name = "jenkins-server"
  }
}

//create production  instane  
resource "aws_instance" "prod" {
  ami           = "ami-0aa8fc2422063977a"
  instance_type = "t2.medium"
  associate_public_ip_address = true
  key_name = aws_key_pair.keypair.id 
  vpc_security_group_ids =  [aws_security_group.production_sg.id]
  user_data = file(("./userdata2.sh"))
  

  tags = {
    Name = "prod-server"
  }
}

 //security group for maven 
resource "aws_security_group" "maven_sg" {
    name = "maven-sg"
    description = "instance_security_group"

  ingress {
    description = "SSH"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "maven-sg"
  }
}

 //security group for jenkins 
resource "aws_security_group" "jenkins_sg" {
    name = "jenkins-sg"
    description = "instance_security_group"

  ingress {
    description = "SSH"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "jenkins-port"
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "jenkins-sg"
  }
}


//security group for production security 
resource "aws_security_group" "production_sg" {
    name = "prod-sg"
    description = "prod_security_group"

  ingress {
    description = "SSH"
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    protocol  = "tcp"
    from_port = 8080
    to_port   = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "production-sg"
  }
}


