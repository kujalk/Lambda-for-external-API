Developer - K.Janarthanan

Architecture
---------------
![alt text](https://github.com/kujalk/Lambda-for-external-API/blob/main/architecture.png)

1. Terraform code is attached in "Terraform"
2. Lambda function is zipped with in "deployment.zip"

Terraform execution
---------------------
1. Make sure you have installed Terraform and set the AWS Profile
2. Update the provider.tf 
3. Update the terraform.tfvars
4. terraform init 
5. terraform apply -auto-approve 
6. To destroy the resources -> terraform destroy -auto-approve 

Note - Current lambda is scheduled at every 5 hrs using CloudWatch Event

Blog
------------
https://scripting4ever.wordpress.com/2022/07/23/lambda-to-call-external-api-and-store-details-in-rds-quick-deployment-using-terraform/


