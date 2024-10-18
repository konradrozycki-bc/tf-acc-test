terraform {
  required_version = ">= 1.9.0"
  required_providers {
    git = {
      source = "metio/git"
      version = ">= 2024.10.11"
    }
  }
}

provider "git" {

}

resource "git_add" "add" {
  directory = "${path.module}/"
  add_paths = ["${path.module}/output_resources.tf"]
}
resource "git_commit" "commit_on_change" {
  directory = "${path.module}/"
  message   = "committed with terraform"

  # lifecycle {
  #   replace_triggered_by = [git_add.add.id]
  # }
}
