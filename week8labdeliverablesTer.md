## Terraform (documentation section)

Create a section called **“terraform”** in your Markdown.

Explain:

- **The mandatory (required) arguments for a VM in Terraform.**
- I looked at the Terraform provider schema for google_compute_instance.
Every argument is marked as:
*Required
*Optional
*Computed
Only three arguments are marked Required:
*name
*machine_type
*zone
Everything else is optional or computed.

- **How to output the internal and external IP addresses of the provisioned VM and how you figured this out.**
- output "vm_ips" {
  value = {
    internal = google_compute_instance.app.network_interface[0].network_ip
    external = google_compute_instance.app.network_interface[0].access_config[0].nat_ip
  }

You can output the internal and external IP addresses of a VM in Terraform by referencing the network_interface attributes that Google Compute Engine exposes after the VM is created. The key is understanding the difference between: the arguments you set (like name), and
the computed attributes Terraform exposes (like network_interface.0.network_ip and network_interface.0.access_config.0.nat_ip).


- **Choose 2 non‑required arguments and give an explanation for both** (do not copy and paste the reference material).
 A description field doesn’t change how the resource behaves, but it does change how humans understand your infrastructure. It’s a place to document intent — why the resource exists, what it connects to, or what problem it solves.
This becomes incredibly useful months later when you’re debugging or when someone else inherits your Terraform. Instead of reverse‑engineering the purpose of a firewall rule or instance template, the description tells the story directly.

Why it matters:
Helps future you (or teammates) understand the resource
Makes the GCP console easier to navigate
Reduces mistakes when modifying infrastructure

The depends_on argument forces Terraform to create resources in a specific order, even when Terraform’s automatic dependency graph thinks it knows better.
You use this when a resource technically has no direct reference to another, but still must wait for it. For example, your forwarding rule depends on the proxy‑only subnet being created first — not because it references it, but because the LB control plane requires that subnet to exist.

Why it matters:
Prevents race conditions
Ensures resources are created in the correct sequence
Avoids destroy‑time failures (like deleting a subnet before the LB is gone)

- **Explain how you would figure out the correct format for creating a VM with the “centOS stream 10” image** (the specific image is up to you).
  Google publishes OS images inside image families, and each family always points to the newest image.
To find the correct CentOS Stream 10 family, you would:
Look up the public image families for CentOS in the centos-cloud project.
Identify the family that corresponds to CentOS Stream 10.
Use that family name in your Terraform resource.

Why this works:
You don’t need to know the exact image name (which changes over time).
Image families are stable and always point to the latest version.
Terraform can reference them directly using source_image_family.

- **Explain the difference between the `name` argument and the computed `id` and `self_link` attributes.**
- Use name when:
You want a readable label
You’re naming resources in your config

✔ Use id when:
Terraform needs to reference the resource internally
You’re debugging state

✔ Use self_link when:
Another GCP resource requires a full URL
You’re wiring resources together (e.g., MIG → instance template → backend service)

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
- <img width="964" height="306" alt="image" src="https://github.com/user-attachments/assets/262527f7-25c8-404c-8fbe-c8af35c161d5" />
 - Ideally with versioning requirements for the Terraform binary of at least `1.10`.
 - 
- Include a `provider {}` block:
- <img width="885" height="216" alt="image" src="https://github.com/user-attachments/assets/41f2eaf9-e440-47bc-af60-68522c050ec0" />

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
- <img width="1066" height="303" alt="image" src="https://github.com/user-attachments/assets/ca85c85d-4ac9-4a0a-a765-e8666e29f0f5" />

- Uses the **“centOS stream 10”** OS image.
- Has a **root persistent disk of 100 GB**.
- Uses a machine type in the **N series** (you choose which).
- <img width="841" height="259" alt="image" src="https://github.com/user-attachments/assets/ff9b881d-2841-4198-aed8-0be71d3d4e75" />

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
