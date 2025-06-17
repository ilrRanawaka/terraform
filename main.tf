terraform {
  required_providers {
    port = {
      source = "port-labs/port-labs"
      version = "~>2.8.0"
    }
  }
}


provider "port" {
  client_id = "5cBl3X5JBganx8BDvmIO8YHEVlViPU85"
  secret    = "zMusN9NI1mxgAqgfsjz5FVXnFnexmgcpdE9j8ba8s1bf1OpIGAlSgfsLLIEPJdGC"
}


resource "port_action" "application_create_it_asset" {
  identifier = "application_create_it_assettrial4"
  description = "Creating a new IT asset in the CMDB. If you have any questions about how to do this, please visit the documentation. [How to create an IT Asset in the CMDB?](https://docsrepo.appslatam.com/x/JwR8Fw)"
  icon = "Stack"
  publish = true
  required_approval = false
  self_service_trigger = {
    operation = "CREATE"
    order_properties = [
      "it_asset_id",
      "description",
      "squad",
      "mfa"
    ]
    blueprint_identifier = "service"
    user_properties = {
      string_props = {
        description = {
          icon = "Book"
          title = "Description"
          description = "Descripción del IT Asset"
          required = true
        }
        it_asset_id = {
          icon = "Version"
          title = "IT Asset ID"
          required = true
          pattern = "^[A-Z0-9_]+$"
          description = "Identificador del IT Asset (debe ser mayuscula y sin guíon medio o caracteres especiales) ejemplo OPSFLET o VSS_CAMERASSSSSS"
        }
        squad = {
          title = "Squad"
          description = "Squad dueño del IT Asset"
          icon = "TwoUsers"
          blueprint = "_team"
          format = "entity"
          required = true
          dataset = {
            combinator = "and"
            rules = [
              {
                property = "$identifier"
                operator = "in"
                value = {
                  jq_query = ".user.team"
                }
              }
               ,{
                 property = "parent_team_id"
                 operator = "isEmpty"
              }
            ]
          }
        }
        mfa = {
          title = "MFA",
          required = true
          enum = [
            "SI",
            "NO",
            "NO APLICA"
          ],
          enum_colors = {
            "SI": "green",
            "NO": "red",
            "NO APLICA": "yellow"
          }
        }
      }
    }
  }
  title = "Crear IT Asset"
  webhook_method = {
    url = "https://example/v1/port-integrations-api/cmdb/create"
    agent = false
    body = jsonencode({
      "action": "it_asset_create",
      "context": {
        "blueprint": "{{.action.blueprint}}",
        "runId": "{{.run.id}}"
      },
      "payload": {
        "properties": {
          "it_asset_description": "{{.inputs.description}}",
          "it_asset_id": "{{.inputs.it_asset_id}}",
          "it_asset_name": "{{.inputs.name}}",
          "it_asset_type": "{{.inputs.it_asset_type.title | ascii_upcase}}",
          "it_asset_solution_type": "{{.inputs.it_asset_solution_type.title}}",
          "mfa": "{{.inputs.mfa}}",
          "squad": "{{.inputs.squad.properties.cmdb_name}}",
          "squad_id": "{{.inputs.squad.identifier}}"
        }
      }
    })
    headers = {
      RUN_ID = "{{ .run.id }}"
      X-API-KEY = "{{ .secrets.x_api_key }}"
    }
    method = "POST"
    synchronized = false
  }
}
