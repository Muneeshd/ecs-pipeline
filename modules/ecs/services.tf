resource "aws_ecs_service" "web-api" {
  name            = "${var.cluster_name}-web"
  task_definition = "${aws_ecs_task_definition.web-api.arn}"
  cluster         = "${aws_ecs_cluster.cluster.id}"
  launch_type     = "FARGATE"
  desired_count   = 2

  depends_on = ["aws_iam_role_policy.ecs_service_role_policy"]

  network_configuration {
    security_groups = ["${var.security_groups_ids}"]
    subnets         = ["${var.availability_zones}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = "${aws_alb_target_group.api_target_group.arn}"
    container_name   = "simple-api"
    container_port   = "80"
  }

  depends_on = ["aws_alb_target_group.api_target_group"]
}
