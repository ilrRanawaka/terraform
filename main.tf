terraform {
  required_providers {
    port = {
      source  = "port-labs/port-labs"
      version = "~> 2.0.3"
    }
  }
}

provider "port" {
  client_id = "5cBl3X5JBganx8BDvmIO8YHEVlViPU85"     # or set the environment variable PORT_CLIENT_ID
  secret    = "zMusN9NI1mxgAqgfsjz5FVXnFnexmgcpdE9j8ba8s1bf1OpIGAlSgfsLLIEPJdGC" # or set the environment variable PORT_CLIENT_SECRET
  base_url  = "https://api.getport.io"
}


resource "port_integration" "terraform-cloud-2" {
  installation_id       = "terraform-cloud-2"
  installation_app_type = "terraform-cloud-2"
  title                 = "Terraform Sync"
  # version               = "0.1.100"
  # The reason for the jsonencode|jsondecode is
  # to preserve the exact syntax as terraform expects,
  # this resolves conflicts in the state caused by indents
  config                = jsonencode(jsondecode(file("${path.module}/terraform_sync_tf.json")))

  #depends_on = [ module.latam-chart ]
}
