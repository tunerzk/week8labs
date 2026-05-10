

# Week 8 Lab – Managed Instance Group & Regional External Application Load Balancer

## Goal

The goal is to create a managed instance group and a regional external application load balancer.

A Regional External Application Load Balancer in Google Cloud works like this:

**Client → Forwarding Rule → Envoy Proxy (Proxy‑only Subnet) → URL Map → Backend Service → Managed Instance Group**

---

## Core concepts

### Load balancing

**Load Balancing:** A process to distribute network traffic across multiple servers (VMs).

### Proxy

**Proxy:** An intermediary between a client and destination server that forwards web requests.

### Autoscaling and autohealing

**Autoscaling:** A key concept in cloud computing that automatically adds or removes servers based on some metric.

**Autohealing:** A key concept in cloud computing that uses health checks that probe servers to ensure they are running properly and, if not, terminates the instance and creates a new one.

---

## Traffic flow and security

The backend VMs never receive traffic directly from the internet. They only receive traffic from the Envoy proxy, which lives in a proxy‑only subnet.

This means:

- Your backend firewall rules must allow traffic **from the proxy subnet**, not from `0.0.0.0/0`.
- The proxy subnet is required for external HTTP(S) load balancers.
- The Envoy proxy handles all request processing before forwarding to your backend.

---

## Deliverables

Use your normal HW GitHub repo to submit this.

- Include all documentation and resources you used, and **how** you used them, and be specific.
- Add a **README** of some kind for this week.
- For all questions and documentation, assume I am a junior employee new to cloud infrastructure:
  - Assume I have some technical knowledge, but you will be covering these concepts from the ground up.

---

## Q & A

Create a section called **“Q & A”** in your repo.

Each bullet point can be between **1–5 sentences**. You choose the amount of detail as long as it shows understanding.

Answer:

- **What is the difference between high availability and fault tolerance? Which is best to strive for?**
- **Explain the difference between autoscaling and elasticity.**
- **What is vertical and horizontal autoscaling? Is one better? Are they feasible on‑prem?**
- **Explain what the difference between managed and unmanaged instance groups is.**
- **Explain the different use cases for health checks used by applications (in instance groups) and health checks used by load balancers.**
  - Can they be the same?
  - Are they different API calls?
  - Should they be the same?
- **Explain in a few sentences what the 3‑tier architecture is and how it relates to what you are learning.**

---

### Prerequisites

Add a section on **prerequisites**:

- What do I, as an engineer, need to have ready to make this happen?

### Steps and key configuration
1. VPC and Subnets
Created VPC: albweek8-vpc

Subnets:

frontend-subnet (for load balancer proxy)

backend-subnet (for MIG VMs)
<img width="1080" height="729" alt="image" src="https://github.com/user-attachments/assets/877987ab-1639-41db-8fe0-05204b7a64d7" />


2. Firewall Rules
Allowed HTTP (tcp:80) to MIG instances
<img width="1470" height="234" alt="image" src="https://github.com/user-attachments/assets/d3df026e-d65d-4756-801c-2ee01c178f7b" />


Allowed Google Load Balancer Health Check IP ranges

130.211.0.0/22

35.191.0.0/16

3. Instance Template
Machine type: e2-medium

Network: albweek8-vpc, backend-subnet
<img width="1469" height="539" alt="image" src="https://github.com/user-attachments/assets/a72c563e-d784-4043-bb05-6adee2b85c0c" />


No external IP (private VM)

Startup script installs Apache and writes an HTML page

4. Cloud NAT
Created alb-nat with router alb-router

Enabled NAT for backend-subnet
<img width="1491" height="357" alt="image" src="https://github.com/user-attachments/assets/a6b4333d-e586-4c7c-8600-a4f834d892dd" />



Allowed MIG VMs to run apt update and install Apache

5. Managed Instance Group (MIG)
Name: week8mig

Zone: us-east1-b

Size: 1

Uses the instance template
<img width="1538" height="362" alt="image" src="https://github.com/user-attachments/assets/e585b713-6696-4b2c-b96f-0556dcf8ef25" />


Autohealing enabled with health check

6. Health Check
Type: HTTP

Port: 80

Path: /

Backend instance now shows Healthy
<img width="1468" height="793" alt="image" src="https://github.com/user-attachments/assets/acb91f4c-483d-4d2d-8174-5d055750a4b4" />


7. Load Balancer
External HTTP Load Balancer

Frontend IP: 35.231.140.15

Backend service: MIG
<img width="1514" height="797" alt="image" src="https://github.com/user-attachments/assets/729c0cf4-1e15-4e14-9be0-41f21d8f9540" />


Health check attached
<img width="797" height="382" alt="image" src="https://github.com/user-attachments/assets/57ba1e03-325e-4b6d-81ed-3d994dbcd7a7" />


URL map + target HTTP proxy configured
<img width="1333" height="463" alt="image" src="https://github.com/user-attachments/assets/215a2f1a-a73a-4a0d-ba31-351de0fa92eb" />




Explain at a high level:

- **How to enable autoscaling and autohealing.**
- Autoscaling is enabled by attaching a scaling policy to the MIG.
This policy defines when the MIG should add or remove instances, usually based on CPU utilization, request load, or a custom metric.
You configure this under the MIG’s Autoscaling tab and specify thresholds (e.g., “add instances when CPU > 60%”).

Autohealing is enabled by attaching a health check to the MIG.
The MIG continuously probes each VM using the health check. If a VM fails the probe, the MIG automatically recreates it.
This is configured under the Autohealing section by selecting a health check and setting a grace period.


- **How to verify that the instance group will manage instances across multiple zones.**
- Check that the MIG type is Regional, not Zonal.
A regional MIG automatically spans three zones in the region (e.g., us-east1-b, us-east1-c, us-east1-d).

Confirm that the Instance Distribution Policy is set.
This policy defines how many instances should run in each zone.
You can view this in the MIG details under Distribution.

After creation, verify that instances are actually placed in multiple zones by checking the Instances tab.
You should see VMs running in more than one zone.


- **Any other critical configuration explicitly.**
- Instance Template  
The MIG must reference a valid instance template. Any changes to the template require updating the MIG and recreating instances.

-Named Ports  
If the MIG is used behind a load balancer, you must define a named port (e.g., http:80) so the backend service knows which port to send traffic to.

-Health Check Compatibility  
The health check used for autohealing must match what your application actually serves (HTTP vs TCP, correct port, correct path).

-Firewall Rules  
Ensure the MIG’s VMs allow:
Load balancer health check ranges
Traffic from the proxy‑only subnet
Application traffic (e.g., port 80)

-Startup Script Reliability  
If your MIG depends on a startup script, ensure it:
Installs required packages
Writes logs
Exits cleanly
A broken startup script will cause the MIG to continuously recreate instances.


Guidance:

- This is for other engineers, so no need to explain like I am nontechnical.
- Runbooks are for **executing** something properly, not for learning from scratch.
- Keep it high level but accurate.
- Test it by having a group mate use this runbook to accomplish the goal:
  - They should be able to rely on it only to spin up a properly configured instance group.

---

## Terraform (documentation section)

Create a section called **“terraform”** in your Markdown.

Explain:

- **The mandatory (required) arguments for a VM in Terraform.**
- **How to output the internal and external IP addresses of the provisioned VM and how you figured this out.**
- **Choose 2 non‑required arguments and give an explanation for both** (do not copy and paste the reference material).
- **Explain how you would figure out the correct format for creating a VM with the “centOS stream 10” image** (the specific image is up to you).
- **Explain the difference between the `name` argument and the computed `id` and `self_link` attributes.**

---

## Terraform subdirectory requirements

In a subdirectory called `terraform`:

### .gitignore

- Include a `.gitignore` file (ask group leader if unsure).

### Critical requirements

- **No state file** can be committed to your repo.
- **No provider binaries** (`.terraform` dir).
- If you somehow figure out Git LFS, still:
  - Your code must be able to be cloned and run (`terraform init`, `terraform validate`, `terraform apply`) **as is**.
- Submission is **not acceptable** without meeting these.

---

## Terraform configuration requirements

The Terraform config must conform to **best practices**.

### Terraform and provider blocks

- Include a `terraform {}` block:
  - Ideally with versioning requirements for the Terraform binary of at least `1.10`.
- Include a `provider {}` block:
  - Use the latest provider version.

### Style and structure

- Add comments where needed to make the config **self‑documenting**.
- Follow style guide for **naming conventions**.
- Use idiomatic formatting (hint: `terraform fmt`).
- Files separated in a logical manner and numbered.
- Resources must logically build on each other.
- No unneeded explicit dependencies.

### VM resource requirements

The Terraform config must provision a **VM** that:

- Has an **external IP**.
- Uses the **“centOS stream 10”** OS image.
- Has a **root persistent disk of 100 GB**.
- Uses a machine type in the **N series** (you choose which).
- Uses the provided **startup script**:
  - Command to get script:

    ```bash
    curl -o startup.sh https://raw.githubusercontent.com/aaron-dm-mcdonald/class7.5-notes/refs/heads/main/week-8/hw/startup-for-rhel.sh
    ```

  - Put the script in the startup script argument however you like.
  - Note: Scripts Theo has provided will not work because CentOS is a flavor of RHEL, so some commands are slightly different.
- Put it in the **default VPC** (or do the BAM, if you choose).
- Use this argument too:

  ```hcl
  tags = ["http-server"]



