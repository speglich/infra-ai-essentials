# GPU Usage Monitoring Stack

This folder contains a docker-compose.yml setup to monitor NVIDIA GPU usage using Prometheus, DCGM Exporter, and Grafana. This setup is intended for developers and teams working with AI workloads, where GPU resource monitoring is critical for performance tuning, cost control, and system health.

Note: This stack depends on Docker and NVIDIA container toolkit, provisioned under /provisioning/docker.

## Why Monitor GPU Usage in AI Workloads?

When training or running inference on machine learning models—especially large deep learning architectures—the GPU is often the most critical and expensive resource in the system. Monitoring GPU usage helps to:

* Detect bottlenecks and optimize resource usage
* Avoid GPU underutilization or saturation
* Track temperature, power usage, memory utilization, and GPU load
* Improve scheduling and workload distribution in shared environments
* Reduce hardware failure risk through proactive monitoring

## Components

1. **Prometheus**

* A time-series database and monitoring system.
* Collects metrics from the DCGM Exporter and stores them for analysis.
* Web interface available at: [http://localhost:9090](http://localhost:9090)

2. **DCGM Exporter**

* NVIDIA’s Data Center GPU Manager (DCGM) exporter.
* Exposes GPU metrics in a format readable by Prometheus (temperature, memory, power, usage, etc.).
* Runs with access to NVIDIA drivers.
* Metrics exposed on port 9400.

3. **Grafana**

* A powerful visualization and dashboarding tool.
* Connects to Prometheus to present GPU metrics graphically.
* Web interface available at: [http://localhost:3000](http://localhost:3000)
* Default login: admin / admin

## How to Use

1. Ensure NVIDIA drivers and the NVIDIA Docker runtime are installed.

2. Go to the /monitoring/gpu-usage directory.

3. Run the following command to start the monitoring stack:

   docker compose up -d

4. Open the following URLs in your browser:

   * Grafana: [http://localhost:3000](http://localhost:3000):
        Default login: admin / admin

### File Structure

```bash
/monitoring/gpu-usage
├── docker-compose.yml
└── prometheus/
└── prometheus.yml
```

The base Docker installation is described in /provisioning/docker.

### Next Steps

Import a pre-configured NVIDIA GPU monitoring dashboard into Grafana from the [Grafana Dashboard Marketplace](https://grafana.com/grafana/dashboards/12239-nvidia-dcgm-exporter-dashboard/) or create a custom dashboard tailored to your system and AI workload.

## Requirements

* Docker and Docker Compose
* NVIDIA Container Toolkit (nvidia-docker2)
* NVIDIA GPU drivers installed on the host system
