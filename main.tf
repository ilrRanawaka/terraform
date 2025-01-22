resource "port_integration" "terraform-cloud" {
  installation_id       = "terraform-cloud"
  installation_app_type = "terraform-cloud"
  title                 = "Terraform Sync"
  # version               = "0.1.100"
  # The reason for the jsonencode|jsondecode is
  # to preserve the exact syntax as terraform expects,
  # this resolves conflicts in the state caused by indents
  config                = jsonencode(jsondecode(file("${path.module}/terraform_sync_tf.json")))

  depends_on = [ module.latam-chart ]
}
