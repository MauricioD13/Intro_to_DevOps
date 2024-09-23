# LAMBDA FUNCTION ROLE

resource "aws_iam_role" "lambda_role" {
  name = "Lambda_Function_role"
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
}


resource "aws_iam_policy" "lambda_function" {

  name        = "aws_iam_policy_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [{
      "Effect" : "Allow",
      "Action" : [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes"
      ],
      "Resource" : "arn:aws:sqs:REGION:ACCOUNT_ID:QUEUE_NAME"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "dynamodb:PutItem"
        ],
        "Resource" : "arn:aws:dynamodb:REGION:ACCOUNT_ID:table/TABLE_NAME"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_function" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_function.arn
}

# EC2 ACCESS to DYNAMODB 

resource "aws_iam_role" "dynamodb_role" {
  name               = "DynamoDB_role"
  assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                        "Service": "lambda.amazonaws.com"
                    },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }

    EOF
}

resource "aws_iam_policy" "dynamodb" {

  name        = "aws_iam_policy_ec2_dynamodb_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "SpecificTable",
          "Effect" : "Allow",
          "Action" : [
            "dynamodb:Query",
            "dynamodb:Scan"
          ],
          "Resource" : aws_dynamodb_table.recipes_table.arn
        },
      ]
  })
}


# SQS ROLE

data "aws_iam_policy_document" "sqs_policy" {
  statement {
    sid    = "AllowSendReceiveMessages"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage"
    ]
    resources = [aws_sqs_queue.recipe_queue.arn]

  }
}

resource "aws_sqs_queue_policy" "sqs_policy" {
  queue_url = aws_sqs_queue.recipe_queue.id
  policy    = data.aws_iam_policy_document.sqs_policy.json
}