resource "aws_db_instance" "db-dev" {
  snapshot_identifier             = "snapshot-from-prod"
  storage_type                    = "gp3"
  instance_class                  = "db.t4g.micro"
  vpc_security_group_ids          = [aws_security_group.private.id]
  db_subnet_group_name            = aws_db_subnet_group.db-subnets.name
  max_allocated_storage           = 40
  publicly_accessible             = false
  storage_encrypted               = true
  enabled_cloudwatch_logs_exports = ["audit", "error"]
  copy_tags_to_snapshot           = true
  backup_retention_period         = 5
  backup_window                   = "01:00-02:00"
  maintenance_window              = "sun:03:00-sun:04:00"
  final_snapshot_identifier       = "db-dev-final-snapshot"
  tags = {
    Name        = "db-tf"
    environment = "dev"
  }
  depends_on = [aws_db_subnet_group.db-subnets, aws_security_group.private]
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.main-dev.id
  ingress {
    from_port   = var.port_db
    to_port     = var.port_db
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name        = "private"
    environment = "dev"
  }
  depends_on = [aws_vpc.main-dev]
}

resource "aws_db_subnet_group" "db-subnets" {
  name       = "main-dev"
  subnet_ids = [aws_subnet.private_0.id, aws_subnet.private_1.id]
  tags = {
    enviroment = "dev"
  }
  depends_on = [aws_subnet.private_0, aws_subnet.private_1]
}
