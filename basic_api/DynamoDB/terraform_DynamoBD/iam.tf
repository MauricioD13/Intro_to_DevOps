
data "aws_iam_policy_document" "ec2_dynamodb" {
    statement {
      sid = "AllowAccessDynamoDB"
      effect = "Allow"
      actions = [ 
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:GetRecords",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem"
      ]
      resources = [ aws_dynamodb_table.recipes_table.arn ]
    }

}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
# Policy that allow to assume a role 
resource "aws_iam_role" "ec2_dynamodb" {
  name = "ec2_dynamodb_role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
# The actual policy that I want to enforce
resource "aws_iam_role_policy" "ec2_dynamodb_role_policy" {
  name = "ec2_dynamodb_policy"
  role = aws_iam_role.ec2_dynamodb.id
  policy = data.aws_iam_policy_document.ec2_dynamodb.json
}

resource "aws_iam_policy" "ec2_dynamodb" {

  name        = "aws_iam_policy_ec2_dynamodb_role"
  path        = "/"
  description = "Policy to allow query and scan resource from DynamoDB"
  policy = data.aws_iam_policy_document.ec2_dynamodb.json
}
resource "aws_iam_policy_attachment" "ec2_dynamodb_attach" {
  name        = "ec2_dynamodb attachment"
  roles       = [ aws_iam_role.ec2_dynamodb.name ]
  policy_arn  = aws_iam_policy.ec2_dynamodb.arn
}



resource "aws_iam_instance_profile" "ec2_dynamodb_profile" {
  name = "ec2_dynamodb_profile"
  role = aws_iam_role.ec2_dynamodb.name

}
