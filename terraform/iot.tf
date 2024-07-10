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

# # モノの作成
# resource "aws_iot_thing" "handson" {
#   name = local.project

#   attributes = {
#     First = ""
#   }
# }

# # デバイス証明書の設定
# ## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iot_certificate
# resource "aws_iot_certificate" "handson" {
#   active = true
# }

# resource "aws_iot_thing_principal_attachment" "handson" {
#   thing = aws_iot_ca_certificate.handson.name
#   principal = aws_iot_ca_certificate.handson.arn
# }
