locals {
  tags = {
    cloud               = "Azure"
    country             = "DDC"
    market              = "global"
    platform            = "DXP"
    department          = "DXP1"
    environment         = "dev"
    geographic_location = "weu"
    project_description = "DXP Core AFD"
    project_name        = "dxp-core-afd"
    project_owner       = "tbd"
    solution_name       = "tbd"
    cost_center         = "devops"
    source              = "terraform"
  }

  # aliases
  rg_alias    = "rg"    # resource group
  afd_alias   = "afd"   # azure front door
  afde_alias  = "afde"  # azure front door endpoint       #
  afdog_alias = "afdog" # azure front door origin group
  afdo_alias  = "afdo"  # azure front door origin
  afdr_alias  = "afdr"  # azure front door route

  # common vars
  prefix   = "${local.cloud}-${local.az}-${local.country}"  #
  suffix   = "${local.env}-${local.project}"                #
  cloud    = "az"                                           #
  az       = "weu"                                          #
  country  = "gl"                                           #
  env      = "dev"                                          #
  project  = "dxp-core-afd"                                 #

  rg_name = "az-weu-gl-rg-dev-dxp-core-01"  #

  # Key Vault
  kv_name                 = "azweuglkvdevdxpcore"          #
  kv_resource_group_name  = "az-weu-gl-rg-dev-dxp-core-01" #
  kv_ssl_certificate_name = " " #

  # Azure Front Door
  afd_name                        = "az-weu-gl-fd-dev-dxp-core-01"                        #
  afde_name                       = "${local.prefix}-${local.afde_alias}-${local.suffix}" #
  afdr_supported_protocols        = ["Http", "Https"]                                     #
  afdr_patterns_to_match          = ["/*"]                                                #
  afdr_forwarding_protocol        = "HttpOnly"                                        #
  afd_secret_name                 = "wildcard-inchcapedigital-com"                        #
  afdog_health_probe_protocol     = "Http"                                                #
  afdog_path                      = "/healthz"                                            #
  afdog_request_type              = "GET"                                                 #

  afd_dev = tomap({
    dev = {
      custom_domain_name       = "dxp-core-afd-dev"
      custom_domain_hostname   = "au-ecom-dev.sample.com"
      route_name               = "afdr-dev"
      afdog_name               = "dev"
      afdo_name                = "afdo-dev"
      afdo_host_name           = " "
    }
    dev-hk = {
      custom_domain_name       = "dxp-core-afd-dev-hk"
      custom_domain_hostname   = "au-ecom-dev-hk.sample.com"
      route_name               = "afdr-dev-hk"
      afdog_name               = "dev-hk"
      afdo_name                = "afdo-dev-hk"
      afdo_host_name           = " "
    }
    sit = {
      custom_domain_name       = "dxp-core-afd-sit"
      custom_domain_hostname   = "au-ecom-sit.sample.com"
      route_name               = "afdr-sit"
      afdog_name               = "sit"
      afdo_name                = "afdo-sit"
      afdo_host_name           = " "
    }
    sit-hk = {
      custom_domain_name       = "dxp-core-afd-sit-hk"
      custom_domain_hostname   = "au-ecom-sit-hk.sample.com"
      route_name               = "afdr-sit-hk"
      afdog_name               = "sit-hk"
      afdo_name                = "afdo-sit-hk"
      afdo_host_name           = " "
    }
    uat = {
      custom_domain_name       = "dxp-core-afd-uat"
      custom_domain_hostname   = "au-ecom-uat.sample.com"
      route_name               = "afdr-uat"
      afdog_name               = "uat"
      afdo_name                = "afdo-uat"
      afdo_host_name           = " "
    }
    uat-hk = {
      custom_domain_name       = "dxp-core-afd-uat-hk"
      custom_domain_hostname   = "au-ecom-uat-hk.sample.com"
      route_name               = "afdr-uat-hk"
      afdog_name               = "uat-hk"
      afdo_name                = "afdo-uat-hk"
      afdo_host_name           = " "
    }
    automation-demo = {
      custom_domain_name       = "dxp-core-afd-automation-demo"
      custom_domain_hostname   = "au-ecom-automation-demo.sample.com"
      route_name               = "afdr-automation-demo"
      afdog_name               = "automation-demo"
      afdo_name                = "afdo-automation-demo"
      afdo_host_name           = " "
    }
    argocd = {
      custom_domain_name       = "dxp-core-afd-argocd"
      custom_domain_hostname   = "argocd-dev.sample.com"
      route_name               = "afdr-argocd"
      afdog_name               = "argocd"
      afdo_name                = "afdo-argocd"
      afdo_host_name           = " "
    }
    pre-prod-aue = {
      custom_domain_name       = "dxp-core-afd-pre-prod-aue"
      custom_domain_hostname   = "au-ecom-preprod.sample.com"
      route_name               = "afdr-pre-prod-aue"
      afdog_name               = "pre-prod-aue"
      afdo_name                = "afdo-pre-prod-aue"
      afdo_host_name           = " "
    }
    pre-prod-au-aue = {
      custom_domain_name       = "dxp-core-afd-pre-prod-au-aue"
      custom_domain_hostname   = "au-ecom-preprod-au.sample.com"
      route_name               = "afdr-pre-prod-au-aue"
      afdog_name               = "pre-prod-au-aue"
      afdo_name                = "afdo-pre-prod-au-aue"
      afdo_host_name           = " "
    }
    pre-prod-hk-aue = {
      custom_domain_name       = "dxp-core-afd-pre-prod-hk-aue"
      custom_domain_hostname   = "au-ecom-preprod-hk.sample.com"
      route_name               = "afdr-pre-prod-hk-aue"
      afdog_name               = "pre-prod-hk-aue"
      afdo_name                = "afdo-pre-prod-hk-aue"
      afdo_host_name           = " "
    }
    pre-prod-dew = {
      custom_domain_name       = "dxp-core-afd-pre-prod-dew"
      custom_domain_hostname   = "eu-ecom-preprod.sample.com"
      route_name               = "afdr-pre-prod-dew"
      afdog_name               = "pre-prod-dew"
      afdo_name                = "afdo-pre-prod-dew"
      afdo_host_name           = " "
    }
    pre-prod-brs = {
      custom_domain_name       = "dxp-core-afd-pre-prod-brs"
      custom_domain_hostname   = "la-ecom-preprod.sample.com"
      route_name               = "afdr-pre-prod-brs"
      afdog_name               = "pre-prod-brs"
      afdo_name                = "afdo-pre-prod-brs"
      afdo_host_name           = " "
    }
    pre-prod-brs-cl = {
      custom_domain_name       = "dxp-core-afd-pre-prod-brs-cl"
      custom_domain_hostname   = "la-ecom-preprod-cl.sample.com"
      route_name               = "afdr-pre-prod-brs-cl"
      afdog_name               = "pre-prod-brs-cl"
      afdo_name                = "afdo-pre-prod-brs-cl"
      afdo_host_name           = " "
    }
    pre-prod-au-ecom-staging = {
      custom_domain_name       = "dxp-core-afd-pre-prod-au-ecom-staging"
      custom_domain_hostname   = "au-ecom-staging.sample.com"
      route_name               = "afdr-pre-prod-au-ecom-staging"
      afdog_name               = "pre-prod-au-ecom-staging"
      afdo_name                = "afdo-pre-prod-au-ecom-staging"
      afdo_host_name           = " "
    }
    pre-prod-eu-ecom-staging = {
      custom_domain_name       = "dxp-core-afd-pre-prod-eu-ecom-staging"
      custom_domain_hostname   = "eu-ecom-staging.sample.com"
      route_name               = "afdr-pre-prod-eu-ecom-staging"
      afdog_name               = "pre-prod-eu-ecom-staging"
      afdo_name                = "afdo-pre-prod-eu-ecom-staging"
      afdo_host_name           = " "
    }
    pre-prod-la-ecom-staging = {
      custom_domain_name       = "dxp-core-afd-pre-prod-la-ecom-staging"
      custom_domain_hostname   = "la-ecom-staging.sample.com"
      route_name               = "afdr-pre-prod-la-ecom-staging"
      afdog_name               = "pre-prod-la-ecom-staging"
      afdo_name                = "afdo-pre-prod-la-ecom-staging"
      afdo_host_name           = " "
    },
  })

  # Placeholder
  afd_placeholder = tomap({
    dev = {
      custom_domain_name       = "dxp-core-afd-dev-new"
      custom_domain_hostname   = "au-ecom-dev-new.sample.com"
      route_name               = "afdr-dev-new"
      afdog_name               = "dev-placeholder"
      afdo_name                = "afdo-dev-placeholder"
      afdo_host_name           = " "
    }
    dev-hk = {
      custom_domain_name       = "dxp-core-afd-dev-hk-new"
      custom_domain_hostname   = "au-ecom-dev-hk-new.sample.com"
      route_name               = "afdr-dev-hk-new"
      afdog_name               = "dev-hk-placeholder"
      afdo_name                = "afdo-dev-hk-placeholder"
      afdo_host_name           = " "
    }
    sit = {
      custom_domain_name       = "dxp-core-afd-sit-new"
      custom_domain_hostname   = "au-ecom-sit-new.sample.com"
      route_name               = "afdr-sit-new"
      afdog_name               = "sit-placeholder"
      afdo_name                = "afdo-sit-placeholder"
      afdo_host_name           = " "
    }
    sit-hk = {
      custom_domain_name       = "dxp-core-afd-sit-hk-new"
      custom_domain_hostname   = "au-ecom-sit-hk-new.sample.com"
      route_name               = "afdr-sit-hk-new"
      afdog_name               = "sit-hk-placeholder"
      afdo_name                = "afdo-sit-hk-placeholder"
      afdo_host_name           = " "
    }
    uat = {
      custom_domain_name       = "dxp-core-afd-uat-new"
      custom_domain_hostname   = "au-ecom-uat-new.sample.com"
      route_name               = "afdr-uat-new"
      afdog_name               = "uat-placeholder"
      afdo_name                = "afdo-uat-placeholder"
      afdo_host_name           = " "
    }
    uat-hk = {
      custom_domain_name       = "dxp-core-afd-uat-hk-new"
      custom_domain_hostname   = "au-ecom-uat-hk-new.sample.com"
      route_name               = "afdr-uat-hk-new"
      afdog_name               = "uat-hk-placeholder"
      afdo_name                = "afdo-uat-hk-placeholder"
      afdo_host_name           = " "
    }
    automation-demo = {
      custom_domain_name       = "dxp-core-afd-automation-demo-new"
      custom_domain_hostname   = "au-ecom-automation-demo-new.sample.com"
      route_name               = "afdr-automation-demo-new"
      afdog_name               = "automation-demo-placeholder"
      afdo_name                = "afdo-automation-demo-placeholder"
      afdo_host_name           = " "
    }
    argocd = {
      custom_domain_name       = "dxp-core-afd-argocd-new"
      custom_domain_hostname   = "argocd-dev-env.sample.com"
      route_name               = "afdr-argocd-new"
      afdog_name               = "argocd-placeholder"
      afdo_name                = "afdo-argocd-placeholder"
      afdo_host_name           = " "
    },
  })

  # Placeholder
  afde_name_placeholder = "${local.prefix}-${local.afde_alias}-${local.suffix}-placeholder" #
}
