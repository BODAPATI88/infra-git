from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import requests

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=[
        "https://platform.bvrinfra.in",
        "https://bvrinfra.in",
        "https://www.bvrinfra.in"
    ],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

PROMETHEUS_URL = "http://10.43.237.166:9090"


@app.get("/")
def root():
    return {
        "status": "ok"
    }


@app.get("/api/v1/cluster-health")
def cluster_health():
    try:
        node_query = "count(kube_node_info)"
        pod_query = "count(kube_pod_info)"
        cpu_query = "avg(100 - (irate(node_cpu_seconds_total{mode='idle'}[5m]) * 100))"
        memory_query = "avg((1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100)"

        nodes = requests.get(
            f"{PROMETHEUS_URL}/api/v1/query",
            params={"query": node_query},
        ).json()

        pods = requests.get(
            f"{PROMETHEUS_URL}/api/v1/query",
            params={"query": pod_query},
        ).json()

        cpu = requests.get(
            f"{PROMETHEUS_URL}/api/v1/query",
            params={"query": cpu_query},
        ).json()

        memory = requests.get(
            f"{PROMETHEUS_URL}/api/v1/query",
            params={"query": memory_query},
        ).json()

        return {
            "status": "healthy",
            "nodes": nodes["data"]["result"],
            "pods": pods["data"]["result"],
            "cpu": cpu["data"]["result"],
            "memory": memory["data"]["result"],
        }

    except Exception as e:
        return {
            "status": "error",
            "message": str(e),
        }
