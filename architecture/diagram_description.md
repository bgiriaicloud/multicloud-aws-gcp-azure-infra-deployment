# Architecture Diagram Description

The architecture consists of three clouds:

1. **AWS**:
   - VPC -> Internet Gateway -> Public Subnet (ALB, NAT GW) -> Private Subnet (EC2) -> Database Subnet (RDS Primary/Standby).
2. **Azure**:
   - VNet -> VNet Gateway -> Public Subnet (App Gateway, NAT GW) -> Private Subnet (VMs) -> Private Endpoint (SQL Database Primary/Replica).
3. **GCP**:
   - VPC -> Cloud Router -> Public Subnet (Load Balancer, Cloud NAT) -> Private Subnet (Compute Engine) -> Private Service Connect (Cloud SQL Primary/Replica).
