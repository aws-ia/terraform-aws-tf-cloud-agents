output "agent_pool_name" {
  description = "Name of the HCP Terraform agent pool."
  value       = try(tfe_agent_pool.ecs_agent_pool[0].name, var.tfe_agent_pool_name)
}

output "agent_pool_id" {
  description = "ID of the HCP Terraform agent pool."
  value       = try(tfe_agent_pool.ecs_agent_pool[0].id, null)
}

output "ecs_service_arn" {
  description = "ARN of the ECS service."
  value       = aws_ecs_service.hcp_terraform_agent.id
}

output "ecs_task_arn" {
  description = "ARN of the ECS task definition."
  value       = aws_ecs_task_definition.hcp_terraform_agent.arn
}

output "ecs_task_revision" {
  description = "Revision number of the ECS task definition."
  value       = aws_ecs_task_definition.hcp_terraform_agent.revision
}

output "log_stream_prefix" {
  description = "Prefix for the CloudWatch log stream."
  value       = jsondecode(aws_ecs_task_definition.hcp_terraform_agent.container_definitions)[0].logConfiguration.options.awslogs-stream-prefix
}

output "security_group_name" {
  description = "Name of the VPC security group attached to the service."
  value       = aws_security_group.hcp_terraform_agent.name
}

output "security_group_id" {
  description = "ID of the VPC security group attached to the service."
  value       = aws_security_group.hcp_terraform_agent.id
}

output "task_role_name" {
  description = "Name of the IAM role attached to the task containers."
  value       = aws_iam_role.ecs_task_role.name
}

output "task_role_arn" {
  description = "ARN of the IAM role attached to the task containers."
  value       = aws_iam_role.ecs_task_role.arn
}
