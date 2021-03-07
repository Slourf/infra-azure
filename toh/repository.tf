resource "azuredevops_serviceendpoint_github" "toh_serviceendpoint_github" {
  project_id            = azuredevops_project.toh.id
  service_endpoint_name = "toh-endpoint-github"

  auth_personal {
    # Also can be set with AZDO_GITHUB_SERVICE_CONNECTION_PAT environment variable
    personal_access_token = "72b03864c53c5b1e94d439d72ad6eb044207d031"
  }
}

resource "azuredevops_git_repository" "toh_repository" {
  project_id = azuredevops_project.toh.id
  name       = "toh-repository"

  initialization {
    init_type = "Import"
    source_type = "Git"
    source_url = "https://github.com/Slourf/Tour-of-Heroes.git"
  }
}