terraform {
  required_version = ">= 1.9.0"
  required_providers {
    git = {
      source = "metio/git"
      version = ">= 2024.10.11"
    }
    github = {
      source = "integrations/github"
      version = "6.3.1"
    }
  }
}

provider "git" {

}

provider "github" {
  # Configuration options
}

/*resource "git_add" "add" {
  directory = "."
  add_paths = ["output_resources.tf"]
}
resource "git_commit" "commit_on_change" {
  directory = "."
  message   = "committed with terraform"

   lifecycle {
     replace_triggered_by = [git_add.add.id]
   }
}

resource "github_repository" "foo" {
  name      = "tf-acc-test"
  auto_init = true
}

resource "github_repository_file" "foo" {
  repository          = github_repository.foo.name
  branch              = "feature/gh-integration"
  file                = "output_resources.tf"
  content             = file("output_resources.tf")
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@example.com"
  overwrite_on_create = true
  autocreate_branch   = true
}
*/

variable "branch_name" {
  description = "Name of the feature branch"
  type        = string
  default     = "feature/feature-branch-"
}

resource "local_file" "example" {
  #content  = "This is the content of the file"
  content = file("output_resources.tf")
  filename = "output_resources.tf"
}

resource "terraform_data" "git_commit_push" {
  input = local_file.example.content
  provisioner "local-exec" {
    command = <<-EOT
      git add ${local_file.example.filename}
      git commit -m "Automated commit from Terraform"
      git branch -M ${var.branch_name}
      git remote add origin https://github.com/konradrozycki-bc/tf-acc-test.git
      git push -u origin ${var.branch_name}
    EOT
    interpreter = ["bash", "-c"]
    working_dir = "."
  }
  lifecycle {
    replace_triggered_by = [local_file.example]
  }
}
