# Project: Fulcrum

**Project: Fulcrum** is a self-hosted, "low-magic" application platform running on a single 6-vCPU/12GB-RAM VPS. It uses a polyglot (Node.js, Python) Docker-first monorepo as the single source of truth. All applications and infrastructure (Postgres, Auth, LLMs) are managed as code, deployed via Git push, and orchestrated by **Coolify**. The platform provides automated CI/CD, centralized authentication (SSO), containerized cron, off-site backups, and local CPU-based LLM inference without requiring Kubernetes or heavy frameworks.

## Core Pillars & Objectives

1.  **Unified Developer Experience:**
    *   A single `git push` builds, tests, and deploys only the applications that have changed (path-filtering).
    *   A single monorepo (`pnpm` + `uv` workspaces) holds all code (apps, packages, infra, migrations).
    *   A `justfile` provides a simple, unified command-line interface for common local tasks (e.g., `just up`, `just db:migrate`).
2.  **Production-Ready Operations (No-SSH):**
    *   Routine operations (deploys, rollbacks, log-viewing, secret management) are handled by the **Coolify** UI, not via SSH.
    *   Automated, nightly, off-site backups of the Postgres database and critical volumes to Google Drive (via `rclone`).
    *   Declarative, version-controlled database migrations (`dbmate` or `Atlas`) that run before app deployment.
3.  **Secure & Extensible by Default:**
    *   Centralized, "perimeter-level" SSO for internal tools (Open WebUI, Dozzle, Uptime-Kuma) using **Authentik** and Traefik ForwardAuth.
    *   Provide a secure, local, OpenAI-compatible API for small LLMs (**Ollama + LiteLLM**) for internal use and experimentation.
    *   All services (Postgres, Ollama, apps) run with strict resource limits (CPU/RAM) to prevent "noisy neighbors" and ensure platform stability.

## Architecture & Core Services

| **Component** | **Technology** | **Purpose & Rationale** |
| --- | --- | --- |
| **Host** | Ubuntu LTS on VPS | 6 vCPU / 12 GB RAM / 100GB+ NVMe. Provisioned with `cloud-init` and `Ansible`. |
| **Platform** | **Coolify** | The core PaaS. Manages Docker, **Traefik** (Ingress/TLS), Postgres, and app lifecycles. |
| **Monorepo** | `pnpm` (Node) + `uv` (Python) | Polyglot workspaces for efficient, shared package management. |
| **CI/CD** | GitHub Actions + GHCR | Build changed apps -> Push images to GHCR -> Trigger Coolify deploy hooks. |
| **Database** | Postgres 16 (in Coolify) | Central datastore for all applications. |
| **Migrations** | `dbmate` | Language-agnostic, SQL-first schema versioning. |
| **Identity** | **Authentik** | Central IdP for SSO. Deployed as a Coolify app. |
| **Auth Proxy** | Traefik ForwardAuth | Secures internal apps at the proxy level (via Coolify labels) using Authentik. |
| **Inference** | **Ollama** + **LiteLLM** | Serves small (3B-7B) quantized models (CPU-only). LiteLLM provides OpenAI API compatibility. |
| **Web UI** | **Open WebUI** | A chat interface for the local Ollama models, protected by Authentik SSO. |
| **Backups** | `rclone` + `pg_dump` | Nightly script (run by Coolify scheduler) to back up DB + volumes to Google Drive. |
| **Task Runner** | `just` | Local task execution (`justfile`). |
| **Observability** | `Dozzle`, `cAdvisor`, `Uptime-Kuma` | Container logs, resource metrics, and external uptime monitoring. |

