# Fulcrum Restore Procedure

This document outlines the steps to restore the Fulcrum platform from backups.

**LAST TESTED:** YYYY-MM-DD

## 1. Prerequisites

- A newly provisioned VPS running Ubuntu LTS.
- Ansible and `rclone` installed on your local machine.
- Access to the Google Drive account containing the backups.

## 2. Infrastructure Restore

1.  **Provision Server:** Run the `infra/ansible/playbook.yml` against the new VPS to configure the base system, install Docker, and set up Coolify.
2.  **Configure Coolify:** Manually configure Coolify with the Git source and deploy the applications. Secrets will need to be re-entered from your password manager.

## 3. Data Restore

1.  **Download Backup:** Use `rclone` to download the latest Postgres backup file from Google Drive to the new VPS.
2.  **Stop Application:** Stop the application services in Coolify that connect to the database.
3.  **Restore Database:** Use `psql` to restore the database dump.
    ```bash
    gunzip < /path/to/postgres-backup.sql.gz | psql -h localhost -U postgres -d app_db
    ```
4.  **Restore Volumes:** If you are backing up other volumes (e.g., Authentik data), extract the tarballs to the correct locations.

## 4. Verification

1.  **Restart Services:** Restart all application services in Coolify.
2.  **Verify Functionality:** Log into the applications and verify that data is present and the system is operational.
