# ASG CONFIG --------------------------------
resource "aws_autoscaling_group" "app" {
  min_size            = 1
  max_size            = 4
  desired_capacity    = 1
  target_group_arns   = [aws_lb_target_group.tg_public.arn]
  vpc_zone_identifier = [aws_subnet.private_app_0.id, aws_subnet.private_app_1.id]
  launch_template {
    id      = aws_launch_template.public.id
    version = "$Latest"
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }
  enabled_metrics = [
    "GroupAndWarmPoolDesiredCapacity",
    "GroupAndWarmPoolTotalCapacity",
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupInServiceInstances",
    "GroupMaxSize",
    "GroupMinSize",
    "GroupPendingCapacity",
    "GroupPendingInstances",
    "GroupStandbyCapacity",
    "GroupStandbyInstances",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances",
    "WarmPoolDesiredCapacity",
    "WarmPoolMinSize",
    "WarmPoolPendingCapacity",
    "WarmPoolTerminatingCapacity",
    "WarmPoolTotalCapacity",
    "WarmPoolWarmedCapacity",
  ]
  tag {
    key                 = "Name"
    value               = "ec2-asg"
    propagate_at_launch = true
  }
}
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app.name
  policy_type            = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 60.0
  }

}

# ASG TEMPLATE CONFIG
resource "aws_launch_template" "public" {
  name                                 = "app-server-template"
  image_id                             = var.app_ami_id
  instance_type                        = "t2.small"
  instance_initiated_shutdown_behavior = "stop"
  key_name                             = "tf-key"
  update_default_version               = true
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2-app-role.name
  }
  monitoring {
    enabled = true
  }

  network_interfaces {
    subnet_id                   = aws_subnet.private_app_0.id
    security_groups             = [aws_security_group.app_instance.id]
    associate_public_ip_address = false
  }
  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      delete_on_termination = true
      volume_type           = "gp3"
      volume_size           = "100"
      encrypted             = true
    }
  }
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  lifecycle {
    create_before_destroy = true
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name                = "app-tf"
      Enviroment          = var.enviroment_tag
      propagate_at_launch = true
    }
  }
}


# IAM ROLE FOR EC2 APP ACCESS TO S3 BUCKET
resource "aws_iam_role" "ec2-app-role" {
  name = "ec2-app-role"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Effect" : "Allow",
        "Sid" : ""
      }
    ]
  })
  tags = {
    Name         = "backups-tf"
    "Enviroment" = var.enviroment_tag
  }
}
resource "aws_iam_policy" "bucket-app" {
  name        = "bucket-app"
  description = "Policy to access S3 bucket from EC2 app"
  policy = jsonencode({
    Version : "2012-10-17",
    Statement : [
      {
        Sid : "Stmt1719265434040",
        Action : [
          "s3:DeleteObject",
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:GetObjectAcl",
          "s3:PutObjectAcl",
          "rds-db:connect",
          "rds:DescribeDBInstances"

        ],
        Effect : "Allow",
        Resource : [
          aws_s3_bucket.static-content.arn,
          aws_db_instance.db_prod.arn
        ]
      }
    ]
  })
  tags = {
    Name         = "backups-tf"
    "Enviroment" = var.enviroment_tag
  }
}

resource "aws_iam_instance_profile" "ec2-app-role" {
  name = "ec2-app-role"
  role = aws_iam_role.ec2-app-role.name

}

resource "aws_iam_role_policy_attachment" "ec2-app-role" {
  role       = aws_iam_role.ec2-app-role.name
  policy_arn = aws_iam_policy.bucket-app.arn

}

resource "aws_instance" "ec2-ami" {

  ami                         = var.ubuntu_ami_id
  instance_type               = "t2.small"
  subnet_id                   = aws_subnet.public_0.id
  associate_public_ip_address = true
  key_name                    = "tf-key"
  iam_instance_profile        = aws_iam_instance_profile.ec2-app-role.name
  vpc_security_group_ids      = [aws_security_group.app_instance.id]
  user_data = base64encode(<<-EOF
            #!/bin/bash
            apt-get update
            apt-get install -y unzip curl
            curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
            apt install unzip
            unzip awscliv2.zip
            sudo ./aws/install
            EOF
  )
  root_block_device {
    volume_size           = 100
    volume_type           = "gp3"
    delete_on_termination = true
  }
  lifecycle {
    prevent_destroy = true
  }
  tags = {
    Name = "ec2-deploy"

  }
}
