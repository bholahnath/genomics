# === README.md ===
# Genomics Platform Engineer

## Overview
This repo sets up an AWS-based pipeline to clean EXIF metadata from uploaded `.jpg` files in S3. Files uploaded to `bucket-akash-a-task` are cleaned by a Lambda function and stored in `bucket-akash-b-task`.

## Setup

### Prerequisites
- Terraform >= 1.0
- AWS CLI with credentials configured
- Python 3.11

### Steps
1. **Install Terraform Modules**
```sh
cd terraform
terraform init
terraform validate
terraform plan
```

2. **Apply Infrastructure**
```sh
terraform apply -auto-approve
```

3. **Package Lambda Code**
```sh
cd lambda
pip install -r requirements.txt -t .
zip -r ../lambda.zip .
```

4. **Upload Image to Test**
Upload a `.jpg` to `bucket-akash-a-genomics`, and check `bucket-akash-b-genomics` for a cleaned version.

## Users
- **userakash**: Full access to Bucket A
- **userbhola**: Read-only access to Bucket B

---
