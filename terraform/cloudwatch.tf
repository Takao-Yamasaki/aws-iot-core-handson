# ロググループの作成
resource "aws_cloudwatch_log_group" "handson" {
  name = "/h4b/iot"
}

# ダッシュボードの作成
resource "aws_cloudwatch_dashboard" "handson" {
  dashboard_body = jsonencode(
    {
      widgets = [
        {
          height     = 6
          properties = {
            query   = <<-EOT
              SOURCE '/h4b/iot' | fields TIMESTAMP, HUMIDITY, TEMPERATURE
              | stats avg(TEMPERATURE),avg(HUMIDITY) by bin(1m)
              | sort TIMESTAMP desc
            EOT
            region  = local.region
            stacked = true
            title   = "/h4b/iot"
            view    = "timeSeries"
          }
          type       = "log"
          width      = 24
          x          = 0
          y          = 0
        },
      ]
    }
  )
  dashboard_name = "h4b-iot-20240711"
}
