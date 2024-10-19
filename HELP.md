# tf-test
## tf commands
- terraform init
- terraform init -upgrade
- terraform fmt
- terraform validate
- terraform plan -var-file=default.tfvars
- terraform apply -auto-approve -var-file=default.tfvars
- terraform destroy -auto-approve -var-file=default.tfvars

## ssh commands
- ssh -i "~/.ssh/<PEM_FILE>" ec2-user@<PUBLIC_IP>

## reference
- [A Simple Public IP Address API](https://api.ipify.org)
- [AWS CLI Command Reference](https://docs.aws.amazon.com/cli/latest/index.html)
- [AWS Provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)