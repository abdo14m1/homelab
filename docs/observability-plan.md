# Cluster Observability Plan

This plan outlines a best-practice path to full observability for the homelab cluster using metrics, logs, traces, and actionable alerting.

## 1) Principles

- Use the **three pillars**: metrics, logs, traces.
- Prefer **OpenTelemetry (OTel)** as the instrumentation and telemetry transport standard.
- Keep ownership clear: platform owns shared observability stack, app owners own service-level instrumentation and dashboards.
- Treat observability as code (GitOps-managed manifests, dashboards, alert rules).

## 2) Current Baseline

- Monitoring namespace and stack are already present (`infrastructure/base/monitoring-stack`).
- VictoriaMetrics stack is already deployed through Flux HelmRelease.
- Grafana operator is present for dashboard and visualization workflows.

## 3) Target Architecture (Best Practice)

### Metrics

- Continue with VictoriaMetrics as long-term metric backend.
- Standardize scrape discovery via `ServiceMonitor`/`PodMonitor`.
- Define recording rules for common cluster and app SLO views.

### Logs

- Add a log pipeline (e.g., Grafana Alloy/Promtail or OTel Collector + Loki-compatible backend).
- Enforce structured JSON logging for first-party workloads where possible.
- Add parsing pipelines for ingress, Kubernetes events, and key app logs.

### Traces

- Introduce an OTel Collector deployment in-cluster.
- Export traces to a trace backend (Grafana Tempo or equivalent).
- Instrument critical workloads first (ingress path, database-backed apps, ML inference path).

### Correlation

- Standardize labels/attributes: `cluster`, `namespace`, `service`, `version`, `environment`.
- Propagate trace/span IDs into application logs to enable trace-to-log pivoting in Grafana.

## 4) Alerting and SLOs

- Define platform SLOs first:
  - API server, node readiness, storage health, DNS, ingress availability.
- Define app SLOs next:
  - Availability, latency (p95/p99), error rate, saturation.
- Route alerts by severity and ownership; avoid noisy alert rules.
- Add runbook links directly in alert annotations.

## 5) Security and Governance

- Restrict observability endpoints with NetworkPolicies and RBAC.
- Redact sensitive fields in logs/traces; never collect secrets/tokens.
- Apply retention policies by data type (short for debug logs, longer for SLO metrics).
- Encrypt telemetry in transit and at rest where supported.

## 6) Rollout Plan (Phased)

### Phase 1: Foundation (Week 1)

- Validate existing monitoring-stack deployment and scrape coverage.
- Add cluster-level golden dashboards (nodes, workloads, networking, storage).
- Establish base alert set with low-noise thresholds.

### Phase 2: Logs (Week 2)

- Deploy cluster-wide log collector and centralized backend.
- Add namespace-level dashboards for log volume and error spikes.
- Create initial log-based alerts for critical services.

### Phase 3: Traces + OTel (Week 3)

- Deploy OTel Collector and default pipelines.
- Instrument top-priority services and expose latency/error trace views.
- Enable log/metric/trace correlation in Grafana dashboards.

### Phase 4: SLO Maturity (Week 4+)

- Finalize service SLOs and burn-rate alerts.
- Add per-service observability scorecard (coverage for metrics/logs/traces/alerts/runbooks).
- Review monthly and tune sampling, retention, and alert quality.

## 7) Definition of Done for “Full Observability”

The cluster is considered fully observable when:

- All critical services emit metrics, logs, and traces.
- Every production service has at least one SLI dashboard and actionable alerts.
- On-call can identify **what failed, where, and why** within minutes using correlated telemetry.
- Runbooks exist for all high-severity alerts.
