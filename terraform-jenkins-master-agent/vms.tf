resource "aws_key_pair" "pub_key" {
  key_name   = "pub_key"
  public_key = file("~/.ssh/id_rsa.pub")
}


resource "aws_instance" "master" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.pub_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.allow_login.id]
  associate_public_ip_address = "true" 
  depends_on = [ aws_instance.agent ] 
  user_data = file("userdata.sh")
  monitoring = "false"
  tags = {
    Name = "jenkins-master"
  }
}

resource "aws_instance" "agent" {
  ami                    = var.ami
  instance_type          =  var.instance_type
  key_name               = aws_key_pair.pub_key.key_name
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  vpc_security_group_ids = [aws_security_group.allow_login.id]
  associate_public_ip_address = "true" 
  user_data = file("userdata.sh")
  tags = {
    Name = "jenkins-agent"
  }
}

resource "null_resource" "master" { 
  depends_on = [ aws_instance.master ]  
    # triggers = { 
    #   always_run = "${timestamp()}" 
    # } 
    provisioner "file" { 
      connection { 
        type = "ssh" 
        user = "ubuntu" 
        private_key = "${file("~/.ssh/id_rsa")}" 
        host = "${aws_instance.master.public_ip}" 
      } 

      source = "master.sh" 
      destination = "/tmp/master.sh"
    }   

    provisioner "remote-exec" { 
      connection { 
        type = "ssh" 
        user = "ubuntu" 
        private_key = "${file("~/.ssh/id_rsa")}" 
        host = "${aws_instance.master.public_ip}"  
      } 

      inline = [ 
        "cd",
        "cp /tmp/master.sh /home/ubuntu/master.sh ",
        "source /home/ubuntu/master.sh",
      ]
    } 
}

resource "null_resource" "agent" { 
  depends_on = [ aws_instance.agent ]  
    # triggers = { 
    #   always_run = "${timestamp()}" 
    # } 
    provisioner "file" { 
      connection { 
        type = "ssh" 
        user = "ubuntu" 
        private_key = "${file("~/.ssh/id_rsa")}" 
        host = "${aws_instance.agent.public_ip}" 
      } 

      source = "agent.sh" 
      destination = "/tmp/agent.sh"     
    }   

    provisioner "remote-exec" { 
      connection { 
        type = "ssh" 
        user = "ubuntu" 
        private_key = "${file("~/.ssh/id_rsa")}" 
        host = "${aws_instance.agent.public_ip}"  
      } 

      inline = [ 
        "cp /tmp/agent.sh /home/ubuntu/agent.sh ",
        "cd ",
        "source /home/ubuntu/agent.sh",
      ]
    } 
} 

output "jenkins_master_public_ip" {
  value = aws_instance.master.public_ip
}
output "jenkins_agent_public_ip" {
  value = aws_instance.agent.public_ip
}