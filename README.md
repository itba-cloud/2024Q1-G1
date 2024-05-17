# LendARead AWS

This project is a continuation of https://github.com/Marco444/LendARead2 with the goal of providing a way to deploy the full stack web application. This project includes a modified version of the original repository as lambdas were added to manage mailing and for storing static files on a S3.

## LendARead's Goal
![Lend a read logo](LendARead2/frontend/public/static/logo-claro.png)

The goal of the web application is to create a community of readers, where all of them can upload their books and request loans from each other. The aim is to allow readers to access books that would not normally be easily accessible.

For example, let's imagine the user Marco, who enjoys reading philosophy in multiple languages. Thanks to other readers with German heritage (for example), he can borrow a philosophy book from a German author that he could not have read by going to a library in Argentina.

## Terraform

First go to the terraform folder
```bash
cd terraform/init
```

Now we need to create the S3 bucket and a DynamoDB to hold the terraform state lock. 

```bash
 terraform init
```

Then, apply the changes (make sure to set the AWS credentials beforehand). Also sample.tfvars holds the sample variables needed (this would change for dev/prod)

```bash
terraform apply -auto-approve -var-file=sample.tfvars
```

After running the command you will see two variables print `dynamodb_table` and `s3_bucket` that are needed later


Next, go to the main architecture folder. Here is the architecture in itself, it will use the `dynamodb_table` and `s3_bucket` to store its state, thus it needs to be built in a two-step fashion.

```bash
cd ../main
```

Now, you need to modify the `backend.tf` file with the values from the last apply, paste them verbatim. This tells Terraform where to store its state.

Let's init the configuration in the main folder:

```bash
terraform init
```

Finally, let's deploy the architecture to AWS 🚀

```bash
terraform apply -auto-approve -var-file=sample.tfvars
```
Note, if running the commands from ARM architecture (e.g. apple silicon) the variable `ecs_task_cpu_architecture` needs to be changed to `ARM64`