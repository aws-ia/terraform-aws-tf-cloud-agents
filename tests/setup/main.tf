data "tfe_organization" "test" {
  name = var.hcp_terraform_org_name
}

resource "tfe_oauth_client" "test" {
  organization     = data.tfe_organization.test.name
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.github_oauth_token_id
  service_provider = "github"
}

resource "tfe_workspace" "test" {
  name           = "test-agent-workspace"
  organization   = data.tfe_organization.test.name
  queue_all_runs = false
  vcs_repo {
    branch         = "main"
    identifier     = var.vcs_repo_identifier
    oauth_token_id = tfe_oauth_client.test.oauth_token_id
  }
}

resource "tfe_workspace_settings" "test" {
  workspace_id   = tfe_workspace.test.id
  agent_pool_id  = var.tfe_agent_pool
  execution_mode = "agent"
}

resource "tfe_workspace_run" "test" {
  workspace_id = tfe_workspace.test.id

  apply {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 0
    retry_backoff_min = 1
  }

  destroy {
    manual_confirm    = false
    wait_for_run      = true
    retry_attempts    = 3
    retry_backoff_min = 10
  }
}
