resource "aws_iam_role" "handson" {
  name = local.project
  assume_role_policy = data.aws_iam_policy_document.handson.json
}

resource "aws_iam_policy" "handson" {
  name = local.project
  policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:PutMetricFilter",
                "logs:PutRetentionPolicy"
            ],
            "Resource": [
                "arn:aws:logs:*:${local.account_id}:log-group:*:log-stream:*"
            ]
        }
    ]
  }
  EOT
}

data "aws_iam_policy_document" "handson" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [ "iot.amazonaws.com" ]
    }
  }
}

resource "aws_iam_policy_attachment" "handson" {
  name = local.project
  roles = [ aws_iam_role.handson.name ]
  policy_arn = aws_iam_policy.handson.arn
}

resource "aws_iam_role" "handson_cw" {
  name = "h4b-iot-cw-logs-rule-20240711"
  assume_role_policy = data.aws_iam_policy_document.handson_cw.json
}

resource "aws_iam_policy" "handson_cw" {
  name = "h4b-iot-cw-logs-rule-20240711"
  policy = <<-EOT
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
            "logs:CreateLogStream",
            "logs:DescribeLogStreams",
            "logs:PutLogEvents"
        ],
        "Resource": [
            "arn:aws:logs:${local.region}:${local.account_id}:log-group:/h4b/iot:*"
        ]
      }
    ]
  }
  EOT
}

data "aws_iam_policy_document" "handson_cw" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [ "iot.amazonaws.com" ]
    }
  }
}

resource "aws_iam_policy_attachment" "handson_cw" {
  name = "h4b-iot-cw-logs-rule-20240711"
  roles = [ aws_iam_role.handson_cw.name ]
  policy_arn = aws_iam_policy.handson_cw.arn
}
