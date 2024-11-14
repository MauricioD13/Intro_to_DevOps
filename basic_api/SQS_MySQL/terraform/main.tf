resource "aws_sqs_queue" "queue" {
  name = "my-queue"
}

data "aws_ami" "main" {
  most_recent = true
  owners = [ "amazon" ]
  filter {
    name = "architecture"
    values = ["arm64"]
  }
  filter {
    name = "name"
    values = [ "al2023-ami-2023" ]
  }

}

resource "aws_instance" "main" {
  ami = data.aws_ami.main.id
  instance_type = "t2.micro"
  
}