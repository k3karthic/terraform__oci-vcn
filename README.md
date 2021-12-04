# Terraform - Create a Virtual Cloud Network in Oracle Cloud

Create a Virtual Cloud Network (VCN) in Oracle Cloud.

The Terraform script below deploys a server under the [Oracle Cloud Always Free](https://www.oracle.com/cloud/free/#always-free) tier,
* terraform__oci-instance-1
	* GitHub: [github.com/k3karthic/terraform__oci-instance-1](https://github.com/k3karthic/terraform__oci-instance-1).
	* Codeberg: [codeberg.org/k3karthic/terraform__oci-instance-1](https://codeberg.org/k3karthic/terraform__oci-instance-1).

## Code Mirrors

* GitHub: [github.com/k3karthic/terraform__oci-vcn](https://github.com/k3karthic/terraform__oci-vcn/)
* Codeberg: [codeberg.org/k3karthic/terraform__oci-vcn](https://codeberg.org/k3karthic/terraform__oci-vcn)

## Configuration

Create a file to store the [Terraform input variables](https://www.terraform.io/docs/language/values/variables.html). Use `india.tfvars.sample` as a reference. Keep `india.tfvars` as the filename or change the name in the following files,

* `bin/plan.sh`

## Deployment

**Step 1:** Use the following command to create a [Terraform plan](https://www.terraform.io/docs/cli/run/index.html#planning),
```
$ ./bin/plan.sh
```

To avoid fetching the latest state of resources, use the following command,
```
$ ./bin/plan.sh -refresh=false
```

**Step 2:** Review the plan using the following command,
```
$ ./bin/view.sh
```

**Step 3:** [Apply](https://www.terraform.io/docs/cli/run/index.html#applying) the plan using the following command,
```
$ ./bin/apply.sh
```

## Encryption

Encrypt sensitive files (Terraform state) before saving them. `.gitignore` must contain the unencrypted file paths.

Use the following command to decrypt the files after cloning the repository,

```
$ ./bin/decrypt.sh
```

Use the following command after running terraform to update the encrypted files,

```
$ ./bin/encrypt.sh <gpg key id>
```

