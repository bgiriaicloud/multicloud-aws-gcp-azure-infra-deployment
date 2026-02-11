# Multi-Cloud Infrastructure Deployment (AWS, Azure, GCP)

This repository contains modularized Terraform code for deploying a comprehensive multi-cloud infrastructure across AWS, Azure, and GCP. The architecture is designed for high availability, security, and scalability, following best practices for each cloud provider.

---

## 🏗️ Architecture Overview

The project implements a secure, multi-tier architecture across all three major cloud providers.

### 🌟 Key Features
- **Security First**: All compute and database resources are deployed in **Private Subnets**. Only Load Balancers are public-facing.
- **High Availability**:
  - **AWS**: Multi-AZ deployment with Auto Scaling Groups and RDS Multi-AZ.
  - **Azure**: Availability Zones with VM Scale Sets and SQL Database redundancy.
  - **GCP**: Multi-Zone Managed Instance Groups and Regional Cloud SQL HA.
- **Edge Security**: Integrated WAF (Web Application Firewall) and CDN (Content Delivery Network) on all clouds.

### ☁️ Cloud-Specific Components

| Feature | AWS | Azure | GCP |
| :--- | :--- | :--- | :--- |
| **DNS** | Route 53 | Azure DNS | Cloud DNS |
| **CDN + WAF** | CloudFront + WAF | Front Door + WAF | Cloud CDN + Cloud Armor |
| **Load Balancing** | Application Load Balancer (ALB) | Application Gateway v2 | Global External HTTP(S) LB |
| **Compute** | EC2 Auto Scaling Group | VM Scale Sets (VMSS) | Managed Instance Group (MIG) |
| **Database** | RDS MySQL (Multi-AZ) | Azure SQL (Private Endpoint) | Cloud SQL MySQL (HA) |

> ℹ️ **Detailed Architecture**: See [architecture/ARCHITECTURE.md](architecture/ARCHITECTURE.md) for a deep dive into the components.

---

## 📂 Project Structure

The project is organized into two main directories: `core-infra` for live deployments and `modules` for reusable resource definitions.

```text
.
├── .github/workflows/       # CI/CD Pipelines
├── architecture/            # Diagrams and Documentation
├── core-infra/              # 🚀 LIVE Infrastructure (Run Terraform Here)
│   ├── aws/                 # AWS Root Module
│   ├── azure/               # Azure Root Module
│   └── gcp/                 # GCP Root Module
└── modules/                 # 📦 Reusable Terraform Modules
    ├── aws/                 # AWS Modules (VPC, Compute, DB, etc.)
    ├── azure/               # Azure Modules (VNet, VMSS, SQL, etc.)
    └── gcp/                 # GCP Modules (VPC, MIG, Cloud SQL, etc.)
```

---

## 🚀 CI/CD with GitHub Actions

Automated deployments are handled via GitHub Actions.

- **Workflow File**: `.github/workflows/infra-deployment.yml`
- **Triggers**:
  - `Pull Request`: Runs `terraform plan` (Validation).
  - `Push to Main`: Runs `terraform apply` (Deployment).
- **Parallel Execution**: The workflow uses a **matrix strategy** to deploy to AWS, Azure, and GCP in parallel.

### 🔐 Required GitHub Secrets

Configure these secrets in your repository settings to enable the pipeline:

| Category | Secret Name | Description |
| :--- | :--- | :--- |
| **AWS** | `AWS_ACCESS_KEY_ID` | Access Key ID |
| | `AWS_SECRET_ACCESS_KEY` | Secret Access Key |
| **Azure** | `ARM_CLIENT_ID` | Service Principal App ID |
| | `ARM_CLIENT_SECRET` | Service Principal Secret |
| | `ARM_SUBSCRIPTION_ID` | Subscription ID |
| | `ARM_TENANT_ID` | Tenant ID |
| **GCP** | `GCP_SA_KEY` | **Full JSON** key for Service Account |
| **TF Vars** | `TF_VAR_SSH_PUBLIC_KEY` | SSH Public Key for VMs |
| | `TF_VAR_DB_PASSWORD` | Master Password for Databases |
| | `TF_VAR_AWS_ALB_SG_ID` | Security Group for ALB |
| | `TF_VAR_AWS_EC2_SG_ID` | Security Group for EC2 |
| | `TF_VAR_AWS_DB_SG_ID` | Security Group for RDS |
| | `TF_VAR_GCP_PROJECT_ID`| GCP Project ID |

---

## 💾 Remote Backends (State Management)

Terraform state is stored securely in the cloud using native storage solutions for each provider.

| Cloud | Backend Type | Storage Resource | Locking Config |
| :--- | :--- | :--- | :--- |
| **AWS** | `s3` | S3 Bucket | DynamoDB Table |
| **Azure** | `azurerm` | Blob Storage Container | Native Lease |
| **GCP** | `gcs` | GCS Bucket | Native Locking |

### 🛠️ Initial Setup (Manual Tasks)

Before running the pipeline, you **must** manually create the backend storage resources:

1.  **AWS**: create an S3 Bucket (e.g., `multi-cloud-aws-state`) and a DynamoDB Table (`terraform-state-lock`, Key: `LockID`).
2.  **Azure**: Create a Storage Account and a Container named `tfstate`.
3.  **GCP**: Create a GCS Bucket (e.g., `multi-cloud-gcp-state`).

### 💻 Local Development

To run Terraform locally, navigate to the specific cloud directory:

```bash
# Example for AWS
cd core-infra/aws

# Initialize (downloads providers and modules)
terraform init

# Review Plan
terraform plan

# Apply
terraform apply
```
