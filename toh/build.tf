resource "azuredevops_variable_group" "vars" {
  project_id   = azuredevops_project.toh.id
  name         = "Infrastructure Pipeline Variables"
  description  = "Managed by Terraform"
  allow_access = true

  variable {
    name  = "FOO"
    value = "BAR"
  }
}

resource "azuredevops_build_definition" "toh-build" {
  project_id = azuredevops_project.toh.id
  name       = "toh-pipeline"
  path       = "\\"

  ci_trigger {
    use_yaml = true
  }

  repository {
    repo_type   = "TfsGit"
    repo_id     = azuredevops_git_repository.toh_repository.id
    branch_name = azuredevops_git_repository.toh_repository.default_branch
    yml_path    = "azure-pipelines.yml"
  }

  variable_groups = [
    azuredevops_variable_group.vars.id
  ]

  variable {
    name  = "PipelineVariable"
    value = "Go Microsoft!"
  }

  variable {
    name      = "PipelineSecret"
    secret_value     = "ZGV2cw"
    is_secret = true
  }
}