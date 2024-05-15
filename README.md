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

Now we need to create the S3 bucket and a DynamoDB to hold the terraform state. As a result, move to the `init/` folder and execute

```bash
 terraform init
```

Luego se aplican los cambios (previamente hay que setear las credenciales de aws en `.aws/credentials`)


```bash
 terraform apply 
```

Esto va a pedir ingresar ciertos valores. Luego de que funcione hay que anotar los valores para dynamodb_table y dynamodb_table

Luego vamos a la arquitectura principal
```bash
cd ../main
```

Y ahora hay que modificar el archivo `backend.tf` con los valores de antes. Esto le dice a terraform donde guarda el estado de terraform. 

Por ultimo, corremos la configuracion


```bash
terraform apply --auto-approve -var-file=dev.tfvars
```