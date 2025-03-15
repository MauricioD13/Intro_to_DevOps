# RDS Instance
resource "aws_db_instance" "db_prod" {
  allocated_storage               = 30
  db_name                         = "Prod"
  storage_type                    = "gp3"
  engine                          = "mysql"
  engine_version                  = "8.0"
  instance_class                  = "db.t3.small"
  username                        = var.db_user
  password                        = var.db_password
  skip_final_snapshot             = false
  vpc_security_group_ids          = [aws_security_group.db_instance.id]
  db_subnet_group_name            = aws_db_subnet_group.db-subnets.name
  max_allocated_storage           = 50
  publicly_accessible             = false
  storage_encrypted               = true
  enabled_cloudwatch_logs_exports = ["audit", "error"]
  multi_az                        = true
  copy_tags_to_snapshot           = true
  backup_retention_period         = 30
  backup_window                   = "01:00-02:00"
  maintenance_window              = "sun:03:00-sun:04:00"
  deletion_protection             = true
  tags = {
    Name          = "db-tf"
    "Environment" = var.enviroment_tag
  }
}

# S3 BUCKET APP CONFIG
resource "aws_s3_bucket" "static-content" {
  bucket = "static-content"

  tags = {
    Name          = "static-content"
    "Environment" = var.enviroment_tag
  }
  lifecycle {
    prevent_destroy = true
  }
}
resource "aws_s3_bucket_versioning" "static-content" {
  bucket = aws_s3_bucket.static-content.id
  versioning_configuration {
    status = "Enabled"
  }
}
resource "aws_s3_object" "private_dir" {
  bucket = aws_s3_bucket.static-content.id
  key    = "private/"
}

resource "aws_s3_bucket_public_access_block" "access-good-app" {
  bucket                  = aws_s3_bucket.static-content.id
  block_public_acls       = false
  block_public_policy     = false
  restrict_public_buckets = false
  ignore_public_acls      = false
}


resource "aws_s3_bucket_policy" "public_read_access" {
  bucket = aws_s3_bucket.static-content.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

data "aws_caller_identity" "current" {}

#S3 Bucket Policy statements
data "aws_iam_policy_document" "allow_public_access" {
  statement {
    sid    = "AllowTerraformAccess"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket",
      "s3:PutBucketPolicy",
      "s3:DeleteBucketPolicy"
    ]
    resources = [
      aws_s3_bucket.static-content.arn,
      "${aws_s3_bucket.static-content.arn}/*"
    ]
  }

  statement {
    sid    = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.static-content.arn}/*"
    ]
  }

  statement {
    sid    = "DenyPublicAccessToPrivate"
    effect = "Deny"
    not_principals {
      type        = "AWS"
      identifiers = [data.aws_caller_identity.current.arn, aws_iam_role.ec2-app-role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion"
    ]
    resources = [
      "${aws_s3_bucket.static-content.arn}/private/*"
    ]
  }

  statement {
    sid    = "AllowEC2Access"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.ec2-app-role.arn]
    }
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetObjectAcl",
      "s3:ListBucket",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:DeleteObject"
    ]
    resources = [
      aws_s3_bucket.static-content.arn,
      "${aws_s3_bucket.static-content.arn}/*"
    ]
  }
}
