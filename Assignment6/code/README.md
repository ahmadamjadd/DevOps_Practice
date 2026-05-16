# Project Overview — Terraform infrastructure

This repository contains Terraform configuration that provisions a small AWS environment used for a single-task assignment. The configuration focuses on networking, an EC2 host, SSH access, and outputting useful identifiers. This README describes what the code creates, how resources relate, and important design assumptions.

## What this project provisions

- A VPC with (one) subnet and basic routing for the assignment.
- Security group(s) that allow SSH (and any assignment-specific ports) to the EC2 instance.
- An EC2 instance that acts as the target virtual machine for the assignment tasks.
- An SSH key pair resource to enable secure access to the EC2 instance.
- Outputs that expose key values after apply (for example, public IP, instance ID).

## High-level architecture

- VPC -> Subnet -> EC2 instance
- Security group attached to EC2 that controls inbound/outbound traffic
- Key pair associated with EC2 for SSH access

The resources are intentionally minimal: a single compute node inside a single subnet to keep the environment simple and deterministic for grading or demonstration.

## Resource details

- VPC (`vpc.tf`): creates the network boundary and subnet used by the instance. Route table entries are minimal; NAT or Internet Gateway usage depends on the exact config in `vpc.tf`.
- Security (`security.tf`): defines security group rules. Expect an inbound rule for SSH (TCP/22) from a restricted CIDR or 0.0.0.0/0 depending on the assignment. Outbound is typically allowed.
- EC2 (`ec2.tf`): provisions an instance (AMI, instance type, user-data if present). The instance uses the key pair defined in `key-pair.tf` and is attached to the security group and subnet.
- Key pair (`key-pair.tf`): creates or references an SSH key pair. If a private key file is generated or provided, treat it as sensitive.
- Outputs (`outputs.tf`): exposes the instance's public IP, instance ID, and any other useful identifiers for connecting or verification.
- Task-specific (`task1.tf`): contains any additional resources required by the assignment (bootstrap scripts, metadata, or simple auxiliary resources).

## File map (what's in the repo)

- `provider.tf` — AWS provider and common provider-level settings.
- `vpc.tf` — VPC, subnet, route table, gateway (if present).
- `security.tf` — security groups and rules controlling access.
- `ec2.tf` — EC2 instance resource and related attachments (network interface, elastic IP if used).
- `key-pair.tf` — key pair resource or key data reference.
- `outputs.tf` — Terraform outputs shown after apply.
- `task1.tf` — assignment-specific resources and examples.
- `terraform.tfstate`, `terraform.tfstate.backup` — local state files (sensitive; do not commit).


## Outputs and verification

After `terraform apply` the key outputs to check are typically:

- Public IP / DNS of the EC2 instance (used to SSH and validate tasks)
- EC2 instance ID
- Any resource IDs used by the assignment tests

Use the outputs to verify the assignment by connecting to the instance or by running provided tests/scripts against the IP.


