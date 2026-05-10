
---

## Runbook

Create a section called **“runbook”**.

### Goal

In the first few sentences (**3 max**) explain the **end goal**.

**Goal:** A fully configured managed instance group created via ClickOps and also Terraform. Deploy a fully configured Managed Instance Group (MIG) using ClickOps that supports autoscaling, autohealing, and multi‑zone instance distribution. The MIG must be based on an instance template and ready for use behind a load balancer.

---

## PREREQUIESITIES
Before executing this runbook, ensure you have:

A valid instance template with a startup script

A VPC and subnet where the MIG will run

A health check created (HTTP or TCP)

IAM permissions:

Compute Instance Admin

Compute Network Admin

Compute Load Balancer Admin

---

Step 1 — Create the Managed Instance Group
Navigate to Compute Engine → Instance groups.

Select Create Instance Group.

Choose New managed instance group.

Select Regional to enable multi‑zone distribution.

Choose your instance template.

Select at least two zones in the region.

Set the initial size (e.g., 1–3 instances).

Create the group.

---

Step 2 — Enable Autohealing
Open the MIG you just created.

Go to the Autohealing tab.

Attach your health check.

Set a grace period (e.g., 300 seconds) to allow startup scripts to finish.

Save.

Autohealing ensures unhealthy VMs are automatically recreated

---

Step 3 — Enable Autoscaling
In the MIG, open the Autoscaling tab.

Enable autoscaling.

Choose a policy, such as:

CPU utilization (e.g., scale out when CPU > 60%)

Requests per second (if behind a load balancer)

Set min/max instance counts.

Save.

---

Step 4 — Verify Multi‑Zone Instance Distribution
Open the MIG.

Go to the Instances tab.

Confirm that instances are running in multiple zones (e.g., us-east1-b, us-east1-c, us-east1-d).

If distribution is uneven, adjust the Instance Distribution Policy.

This ensures high availability across zones.

---

Step 5 — Critical Configuration Checks
Before considering the MIG production‑ready, verify:

Named ports are configured if using a load balancer

Firewall rules allow:

Health check ranges

Proxy‑only subnet

Application traffic (e.g., port 80)

Startup script completes successfully

Instance template is correct (MIG cannot modify VMs directly)

Autohealing + autoscaling do not conflict (e.g., too short grace period)

---

Step 6 — Test the MIG
Manually stop an instance → MIG should recreate it (autohealing).

Generate load → MIG should scale out (autoscaling).

Reduce load → MIG should scale in.

Delete a zone’s instance → MIG should recreate it in another zone.

## TEST MIG BEHAVIOR

---



