run "agent_is_setup" {
  command = apply
  module {
    source = "./tests/setup_agent"
  }
  # agent pool id should start with apool-xxxxx
  assert {
    condition     = substr(module.agent_pool.agent_pool_id, 0, 5) == "apool"
    error_message = "Invalid agent pool id"
  }
}

run "validate_terraform_apply" {
  command = apply
  module {
    source = "./tests/validate_apply"
  }

  variables {
    tfe_agent_pool = run.agent_is_setup.agent_pool_id
  }

  assert {
    condition     = data.tfe_workspace.test.runs_count > 0
    error_message = "Workspace run count is zero, indicating plan / apply did not run"
  }

  assert {
    condition     = data.tfe_workspace.test.run_failures == 0
    error_message = "Workspace run failure is bigger than zero"
  }

  assert {
    condition     = data.tfe_workspace.test.resource_count > 0
    error_message = "No resources created, indicating apply is failing"
  }
}