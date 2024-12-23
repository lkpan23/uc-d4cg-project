# University of Chicago, Data for the Common Good (D4CG) Project

This project sets up an AWS Lambda function triggered by a CloudWatch Event Rule (cron job) using Terraform. The Lambda function code is stored in an S3 bucket, and the necessary IAM roles and policies are created to allow the Lambda function to execute and interact with AWS services.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.9
- AWS account with necessary permissions

## Project Structure

- `variables.tf`: Defines the input variables for the Terraform configuration.
- `s3.tf`: Configures the S3 bucket and related resources.
- `lambda.tf`: Configures the Lambda function, IAM roles, and CloudWatch Event Rule.
- `outputs.tf`: Defines the outputs of the Terraform configuration.
- `configurations/lambda-deploy.tfvars`: Contains the variable values for deploying the Lambda function.
- `.github/workflows/deploy.yml`: GitHub Actions workflow for deploying the Lambda function.
- `.github/workflows/build.yml`: GitHub Actions workflow for building and validating the Terraform configuration.

## Usage

1. **Clone the repository:**

    ```sh
    git clone <repository-url>
    cd uc-d4cg-project
    ```

2. **Initialize Terraform:**

    ```sh
    terraform init
    ```

3. **Review and modify variables:**

    Edit the `configurations/lambda-deploy.tfvars` file to set the desired values for the variables.

4. **Plan the deployment:**

    ```sh
    terraform plan -var-file=configurations/lambda-deploy.tfvars
    ```

5. **Apply the deployment:**

    ```sh
    terraform apply -var-file=configurations/lambda-deploy.tfvars
    ```

6. **Destroy the deployment:**

    To remove all resources created by this Terraform configuration, run:

    ```sh
    terraform destroy -var-file=configurations/lambda-deploy.tfvars
    ```

## GitHub Actions Workflows

### Terraform AWS Cron Lambda Deploy

This workflow is defined in `.github/workflows/deploy.yml` and runs on push to the `main` branch or can be manually triggered. It performs the following actions:

- Checks out the repository
- Sets up AWS credentials
- Sets up Terraform
- Initializes Terraform
- Plans the deployment
- Applies the deployment

### Terraform AWS Cron Lambda Build

This workflow is defined in `.github/workflows/build.yml` and runs on pull requests. It performs the following actions:

- Checks out the repository
- Sets up AWS credentials
- Sets up Terraform
- Formats the Terraform code
- Initializes Terraform
- Validates the Terraform configuration
- Plans the deployment

## Inputs

The following input variables are defined in `variables.tf`:

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| aws_region | The AWS region to deploy the resources | `string` | `"us-east-1"` | no |
| cw_event_rule_name | The name of the CloudWatch Event Rule | `string` | `"lambda_cron_event_rule"` | no |
| iam_policy_name | The name of the IAM policy | `string` | `"lambda_permissions_policy"` | no |
| iam_role_name | The name of the IAM role to create for the Lambda function | `string` | `"lambda_execution_role"` | no |
| lambda_function_name | The name of the Lambda function | `string` | `"cron_lambda_function"` | no |
| s3_bucket_name | Name of the S3 bucket to create | `string` | `"lambda-code-bucket"` | no |
| s3_bucket_versioning_status | The versioning status of the S3 bucket | `string` | `"Enabled"` | no |
| kms_key_deletion_window_in_days | The number of days before the KMS key is deleted | `number` | `7` | no |
| bucket_object_lock_configuration_days | The number of days to retain the object in the bucket | `number` | `5` | no |

## Outputs

The following output is defined in `outputs.tf`:

| Name | Description |
|------|-------------|
| lambda_function_name | The name of the deployed Lambda function |

## License

This project is licensed under the MIT License.
