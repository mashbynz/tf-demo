# tf-demo

## How to use this repo

1. Create a directory in the cloned repo called "dev"
2. Create a file in this directory called "backend.tfvars"
3. Paste in the following content, substituting your values as appropriate:

``` 
resource_group_name  = "<Resource Group name>"
storage_account_name = "<Storage Account name>"
container_name       = "<container name>"
key                  = "terraformDemo.tfstate"
access_key           = "<ACCESS_KEY from the storage account>"

subscription_id      = "<your SUBSCRIPTION_ID>"
tenant_id            = "<your TENANT_ID>"

client_id            = "<'appId' from Service Principal creation>"
client_secret        = "<'password' from Service Principal creation>"
```

