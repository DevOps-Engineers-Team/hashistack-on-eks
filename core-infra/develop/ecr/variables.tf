locals {
  environment   = basename(dirname(path.cwd))
  config_name = basename(dirname(dirname(path.cwd)))
  account_id = data.aws_caller_identity.current.account_id

  ecr_config = {
    tfenv = {
      name =  "tfenv"
    }
    nomad = {
      name = "nomad"
    }
  }

  repo_pull_permissions =  [
    "arn:aws:iam::${local.account_id}:root",
  ]

  repo_push_permissions =  [
    "arn:aws:iam::${local.account_id}:root",
  ]
}

# variable "repo_pull_permissions" {
#     type = list(string)
#     default = [
#       "arn:aws:iam::${local.account_id}:root",
#     ]
# }

# variable "repo_push_permissions" {
#     type = list(string)
#     default = [
#       "arn:aws:iam::${local.account_id}:root"
#     ]
# }
