# tf-demo

## How to use this repo

1. Create a new file in the cloned repo called "demo.auto.tfvars"
2. Paste in the following content, substituting your values as appropriate:

``` 
## State
lowerlevel_storage_account_name = "<your Storage Account name>"
lowerlevel_container_name       = "tfstate"
lowerlevel_resource_group_name  = "demostate-rg"
lowerlevel_key                  = "demo.tfstate"

## Resource Groups
rg_suffix   = "-rg"
vnet_suffix = "-vnet"

resource_groups = {
  region1_network1 = {
    name     = "demonetwork"
    location = "australiaeast"
    tags = {
      application = "Networking"
      role        = "Demo"
      location    = "Australia East"
    }
  },
}

# Networking
networking_object = {
  vnet = {
    region1_network1 = {
      name               = "demonetwork"
      location           = "australiaeast"
      virtual_network_rg = "demonetwork-rg"
      address_space      = ["10.6.0.0/16"] # 10.6.0.0 - 10.6.255.255
      dns                = ["10.6.1.6"]
      enable_ddos_std    = false
      ddos_id            = ""
      tags = {
        application = "Networking"
        role        = "Demo"
        location    = "Australia East"
      }
    }
  }
  subnets = {
    region1_Subnet1 = {
      name                 = "subnet1"
      cidr                 = "10.6.1.0/24"
      location             = "australiaeast"
      virtual_network_rg   = "demonetwork-rg"
      virtual_network_name = "demonetwork-vnet"
      service_endpoints    = []
      tags = {
        application = "Networking"
        role        = "Demo"
        location    = "Australia East"
      }
    }
    region1_Subnet2 = {
      name                 = "subnet2"
      cidr                 = "10.6.2.0/26"
      location             = "australiaeast"
      virtual_network_rg   = "demonetwork-rg"
      virtual_network_name = "demonetwork-vnet"
      service_endpoints    = []
      tags = {
        application = "Networking"
        role        = "Demo"
        location    = "Australia East"
      }
    }
  }
}
```

