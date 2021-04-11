# Terraform - Create a Virtual Cloud Network in the Oracle Cloud
Create a Virtual Cloud Network in Oracle Cloud; this will serve as the default VCN for all future deployments

## Encryption

Sensitive files like the input variables (india.tfvars) and Terraform state files are encrypted before being stored in the repository.

Use the following command to decrypt the files after cloning the repository,

```
./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
./bin/encrypt.sh <gpg key id>
```

## Deployment

### Step 1

Create a Terraform plan by running plan.sh; the script will read input variables from the file india.tfvars

```
./bin/plan.sh
```

To avoid fetching the latest state of resources from OCI, run the following command

```
./bin/plan.sh --refresh=false
```

### Step 2

Review the generated plan

```
./bin/view.sh
```

### Step 3

Run the verified plan

```
./bin/apply.sh
```
