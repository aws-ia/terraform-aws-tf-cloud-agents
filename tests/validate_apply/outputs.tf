output "tfe_workspace_run_failure" {
  value = data.tfe_workspace.test.run_failures
}

output "tfe_workspace_run_count" {
  value = data.tfe_workspace.test.runs_count
}

output "tfe_workspace_resource_count" {
  value = data.tfe_workspace.test.resource_count
}