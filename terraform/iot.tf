# IoTポリシーの作成
## https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/iot_policy
resource "awscc_iot_policy" "handson" {
  policy_name = "h4b-iot-policy-20240710"
  policy_document = jsonencode(
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Action": "iot:Connect",
          "Resource": "arn:aws:iot:${local.region}:${local.account_id}:client/$${iot:Connection.Thing.ThingName}"
        },
        {
          "Effect": "Allow",
          "Action": "iot:Publish",
          "Resource": [
            "arn:aws:iot:${local.region}:${local.account_id}:topic/data/$${iot:Connection.Thing.ThingName}",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/get"
          ]
        },
        {
          "Effect": "Allow",
          "Action": "iot:Receive",
          "Resource": [
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/delta",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/accepted",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/rejected",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/get/accepted",
            "arn:aws:iot:${local.region}:${local.account_id}:topic/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/get/rejected"
          ]
        },
        {
          "Effect": "Allow",
          "Action": "iot:Subscribe",
          "Resource": [
            "arn:aws:iot:${local.region}:${local.account_id}:topicfilter/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/delta",
            "arn:aws:iot:${local.region}:${local.account_id}:topicfilter/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/accepted",
            "arn:aws:iot:${local.region}:${local.account_id}:topicfilter/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/update/rejected",
            "arn:aws:iot:${local.region}:${local.account_id}:topicfilter/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/get/accepted",
            "arn:aws:iot:${local.region}:${local.account_id}:topicfilter/$aws/things/$${iot:Connection.Thing.ThingName}/shadow/get/rejected"
          ]
        }
      ]
    }
  )
}

# IoTのログ記録に設定
resource "aws_iot_logging_options" "handson" {
  role_arn = aws_iam_role.handson.arn
  default_log_level = "INFO"
}

# モノの作成
resource "aws_iot_thing" "handson" {
  name = local.project
}

# デバイス証明書の設定
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_certificate
resource "aws_iot_certificate" "handson" {
  certificate_pem = file("../5ccf03f9a512a4a0d01c9ab6e8da0aebe08935106f9778343d60aa4c22a15a5d-certificate.pem.crt")
  active = true
}

# モノと証明書の関連付け
resource "aws_iot_thing_principal_attachment" "handson" {
  thing = aws_iot_thing.handson.name
  principal = aws_iot_certificate.handson.arn
}

# 証明書とポリシーの関連付け
resource "aws_iot_policy_attachment" "handson" {
  policy = awscc_iot_policy.handson.policy_name
  target = aws_iot_certificate.handson.arn
}

# ルールの作成
## https://registry.terraform.io/providers/hashicorp/awscc/latest/docs/resources/iot_topic_rule
resource "aws_iot_topic_rule" "handson" {
  name = "h4b_iot_rule_20240710"
  description = "Rule to save message to CloudWatch"
  enabled = true
  sql = "SELECT * FROM 'data/h4b-yamasaki-20240710'"
  sql_version = "2016-03-23"

  cloudwatch_logs {
    log_group_name = aws_cloudwatch_log_group.handson.name
    role_arn = aws_iam_role.handson_cw.arn
  }
}
