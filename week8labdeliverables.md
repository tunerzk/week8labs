

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

## Runbook

Create a section called **“runbook”**.

### Goal

In the first few sentences (**3 max**) explain the **end goal**.

**Goal:** A fully configured managed instance group created via ClickOps.

### Prerequisites

Add a section on **prerequisites**:

- What do I, as an engineer, need to have ready to make this happen?

### Steps and key configuration

Explain at a high level:

- **How to enable autoscaling and autohealing.**
- **How to verify that the instance group will manage instances across multiple zones.**
- **Any other critical configuration explicitly.**

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



