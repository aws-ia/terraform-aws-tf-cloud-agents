output "agent_pool_name" {
  description = "Name of the HCP Terraform or HCP Terraform Enterprise agent pool."
  value       = module.agent_pool.agent_pool_name
}

output "agent_pool_id" {
  description = "ID of the HCP Terraform or HCP Terraform Enterprise agent pool."
  value       = module.agent_pool.agent_pool_id
}

output "ecs_service_arn" {
  description = "ARN of the ECS service."
  value       = module.agent_pool.ecs_service_arn
}

output "ecs_task_arn" {
  description = "ARN of the ECS task definition."
  value       = module.agent_pool.ecs_task_arn
}

output "ecs_task_revision" {
  description = "Revision number of the ECS task definition."
  value       = module.agent_pool.ecs_task_revision
}

output "log_stream_prefix" {
  description = "Prefix for the CloudWatch log stream."
  value       = module.agent_pool.log_stream_prefix
}

output "security_group_name" {
  description = "Name of the VPC security group attached to the service."
  value       = module.agent_pool.security_group_name
}

output "security_group_id" {
  description = "ID of the VPC security group attached to the service."
  value       = module.agent_pool.security_group_id
}

output "task_role_name" {
  description = "Name of the IAM role attached to the task containers."
  value       = module.agent_pool.task_role_name
}

output "task_role_arn" {
  description = "ARN of the IAM role attached to the task containers."
  value       = module.agent_pool.task_role_arn
}
