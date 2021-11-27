

# alarma de escalado hacia arriba
resource "aws_autoscaling_policy" "my-cpu-policy-scaleup" {
  name                   = "my-cpu-policy-scaleup"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 60 //tiempo de espera para volver a activar auto scaling
  policy_type            = "SimpleScaling"
}

# metricas de configuracion para el escalado hacia arriba
resource "aws_cloudwatch_metric_alarm" "my-cpu-alarm" {
  alarm_name          = "${var.prefix_name}-alarmacpu-escaladoarriba"
  alarm_description   = "${var.prefix_name}-alarmacpu-escaladoarriba"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60 //tiempo en que tienen que estar las instancias antes de activar el autoescalado
  statistic           = "Average"
  threshold           = var.max_cpu_percent_alarm// porcentaje maximo de CPU

  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.my-cpu-policy-scaleup.arn]
}






# alarma de escalado hacia abajo
resource "aws_autoscaling_policy" "my-cpu-policy-scaledown" {
  name                   = "${var.prefix_name}-cpu-policy-scaledown"
  autoscaling_group_name = var.asg_name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 60 //estaba en 300
  policy_type            = "SimpleScaling"
}

# metricas de configuracion para el escalado hacia abajo
resource "aws_cloudwatch_metric_alarm" "my-cpu-alarm-scaledown" {
  alarm_name          = "${var.prefix_name}-alarmacpu-escaladoaabajo"
  alarm_description   = "${var.prefix_name}-alarmacpu-escaladoaabajo"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60// va a escalar hacia abajo despues de 1 minutos
  statistic           = "Average"
  threshold           = var.min_cpu_percent_alarm

  dimensions = {
    "AutoScalingGroupName" = var.asg_name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.my-cpu-policy-scaledown.arn]
}

# # email subscription is currently unsupported in terraform and can be done using the AWS Web Console
# resource "aws_autoscaling_notification" "my-notify" {
#  group_names = ["${var.asg_name}"]
#  topic_arn     = "${aws_sns_topic.my-sns.arn}"
#  notifications  = [
#    "autoscaling:EC2_INSTANCE_LAUNCH",
#    "autoscaling:EC2_INSTANCE_TERMINATE",
#    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR"
#  ]
# }
