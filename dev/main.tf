data "azurerm_cdn_frontdoor_profile" "afd" {
  name                = local.afd_name
  resource_group_name = local.rg_name
}

resource "azurerm_cdn_frontdoor_endpoint" "afde" {
  name                     = local.afde_name
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id
  enabled                  = false #remove/comment/true during switch

  depends_on = [data.azurerm_cdn_frontdoor_profile.afd]
}

#Placeholder
resource "azurerm_cdn_frontdoor_endpoint" "afde-placeholder" {
  name                     = local.afde_name_placeholder
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id

  depends_on = [data.azurerm_cdn_frontdoor_profile.afd]
}

resource "azurerm_cdn_frontdoor_origin_group" "afdog" {
  for_each                 = local.afd_dev
  name                     = each.value["afdog_name"]
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id
  session_affinity_enabled = false
  health_probe {
    protocol            = local.afdog_health_probe_protocol
    path                = local.afdog_path
    request_type        = local.afdog_request_type
    interval_in_seconds = 100
  }
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

#Placeholder
resource "azurerm_cdn_frontdoor_origin_group" "afdog_placeholder" {
  for_each                 = local.afd_placeholder
  name                     = each.value["afdog_name"]
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id
  session_affinity_enabled = false
  health_probe {
    protocol            = local.afdog_health_probe_protocol
    path                = local.afdog_path
    request_type        = local.afdog_request_type
    interval_in_seconds = 100
  }
  load_balancing {
    sample_size                 = 4
    successful_samples_required = 3
  }
}

resource "azurerm_cdn_frontdoor_origin" "afdo" {
  for_each                       = local.afd_dev
  name                           = each.value["afdo_name"]
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afdog[each.key].id
  enabled                        = true
  host_name                      = each.value["afdo_host_name"]
  http_port                      = 80
  https_port                     = 80
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true

  depends_on = [azurerm_cdn_frontdoor_origin_group.afdog]
}

#Placeholder
resource "azurerm_cdn_frontdoor_origin" "afdo_placeholder" {
  for_each                       = local.afd_placeholder
  name                           = each.value["afdo_name"]
  cdn_frontdoor_origin_group_id  = azurerm_cdn_frontdoor_origin_group.afdog_placeholder[each.key].id
  enabled                        = true
  host_name                      = each.value["afdo_host_name"]
  http_port                      = 80
  https_port                     = 80
  priority                       = 1
  weight                         = 1000
  certificate_name_check_enabled = true

  depends_on = [azurerm_cdn_frontdoor_origin_group.afdog_placeholder]
}

data "azurerm_key_vault" "kv" {
  name                = local.kv_name
  resource_group_name = local.kv_resource_group_name
}

data "azurerm_key_vault_certificate" "ssl_cert" {
  name         = local.kv_ssl_certificate_name
  key_vault_id = data.azurerm_key_vault.kv.id
}

resource "azurerm_cdn_frontdoor_secret" "afd_secret" {
  name                     = local.afd_secret_name
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id

  secret {
    customer_certificate {
      key_vault_certificate_id = data.azurerm_key_vault_certificate.ssl_cert.versionless_id
    }
  }
}

resource "azurerm_cdn_frontdoor_custom_domain" "afd_domains" {
  for_each                 = local.afd_dev
  name                     = each.value["custom_domain_name"]
  host_name                = each.value["custom_domain_hostname"]
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id

  tls {
    certificate_type        = "CustomerCertificate"
    minimum_tls_version     = "TLS12"
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.afd_secret.id
  }
}

# Placeholder
resource "azurerm_cdn_frontdoor_custom_domain" "afd_domains_placeholder" {
  for_each                 = local.afd_placeholder
  name                     = each.value["custom_domain_name"]
  host_name                = each.value["custom_domain_hostname"]
  cdn_frontdoor_profile_id = data.azurerm_cdn_frontdoor_profile.afd.id

  tls {
    certificate_type        = "CustomerCertificate"
    minimum_tls_version     = "TLS12"
    cdn_frontdoor_secret_id = azurerm_cdn_frontdoor_secret.afd_secret.id
  }
}

resource "azurerm_cdn_frontdoor_route" "afdr" {
  for_each                      = local.afd_dev
  name                          = each.value["route_name"]
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afde.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afdog[each.key].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.afdo[each.key].id]
  enabled                       = false #remove/comment/true during switch

  supported_protocols    = local.afdr_supported_protocols
  patterns_to_match      = local.afdr_patterns_to_match
  forwarding_protocol    = local.afdr_forwarding_protocol
  https_redirect_enabled = true

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.afd_domains[each.key].id]
  link_to_default_domain          = false

  depends_on = [azurerm_cdn_frontdoor_origin.afdo]
}

#Placeholder
resource "azurerm_cdn_frontdoor_route" "afdr_placeholder" {
  for_each                      = local.afd_placeholder
  name                          = each.value["route_name"]
  cdn_frontdoor_endpoint_id     = azurerm_cdn_frontdoor_endpoint.afde-placeholder.id
  cdn_frontdoor_origin_group_id = azurerm_cdn_frontdoor_origin_group.afdog_placeholder[each.key].id
  cdn_frontdoor_origin_ids      = [azurerm_cdn_frontdoor_origin.afdo_placeholder[each.key].id]

  supported_protocols    = local.afdr_supported_protocols
  patterns_to_match      = local.afdr_patterns_to_match
  forwarding_protocol    = local.afdr_forwarding_protocol
  https_redirect_enabled = true

  cdn_frontdoor_custom_domain_ids = [azurerm_cdn_frontdoor_custom_domain.afd_domains_placeholder[each.key].id]
  link_to_default_domain          = false

  depends_on = [azurerm_cdn_frontdoor_origin.afdo_placeholder]
}

resource "azurerm_cdn_frontdoor_custom_domain_association" "afd_domain_association" {
  for_each                       = local.afd_dev
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.afd_domains[each.key].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.afdr[each.key].id]
}

# Placeholder
resource "azurerm_cdn_frontdoor_custom_domain_association" "afd_domain_association_placeholder" {
  for_each                       = local.afd_placeholder
  cdn_frontdoor_custom_domain_id = azurerm_cdn_frontdoor_custom_domain.afd_domains_placeholder[each.key].id
  cdn_frontdoor_route_ids        = [azurerm_cdn_frontdoor_route.afdr_placeholder[each.key].id]
}
