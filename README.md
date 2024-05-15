# LendARead AWS

This project is a continuation of https://github.com/Marco444/LendARead2 with the goal of providing a way to deploy the full stack web application. This project includes a modified version of the original repository as lambdas were added to manage mailing and for storing static files on a S3.

## LendARead's Goal
![Lend a read logo](LendARead2/frontend/public/static/logo-claro.png)

The goal of the web application is to create a community of readers, where all of them can upload their books and request loans from each other. The aim is to allow readers to access books that would not normally be easily accessible.

For example, let's imagine the user Marco, who enjoys reading philosophy in multiple languages. Thanks to other readers with German heritage (for example), he can borrow a philosophy book from a German author that he could not have read by going to a library in Argentina.

## Terraform

First go to the terraform folder
```bash
cd terraform
```

Now we need to create the S3 bucket and a DynamoDB to hold the terraform state lock. As a result, move to the `init/` folder and execute

```bash
 terraform init
```

Then, apply the changes (make sure to set the AWS credentials beforehand):

```bash
 terraform apply 
```

This will prompt you to enter certain values. After it runs successfully, note down the values for `dynamodb_table` and `s3_bucket`.


Next, go to the main architecture folder:

```bash
cd ../main
```

Now, you need to modify the `backend.tf` file with the values noted earlier. This tells Terraform where to store its state.

Finally, run the configuration:


```bash
terraform apply --auto-approve -var-file=dev.tfvars
```
