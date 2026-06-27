#!/bin/bash
# Common functions for installation scripts

set -e

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Wait for deployment to be ready
wait_for_deployment() {
    local namespace=$1
    local deployment=$2
    local timeout=${3:-300}
    
    log_info "Waiting for deployment $deployment in namespace $namespace..."
    kubectl wait --for=condition=available --timeout=${timeout}s deployment/$deployment -n $namespace
}

# Wait for pod to be ready
wait_for_pod() {
    local namespace=$1
    local label=$2
    local timeout=${3:-300}
    
    log_info "Waiting for pod with label $label in namespace $namespace..."
    kubectl wait --for=condition=ready pod -l $label -n $namespace --timeout=${timeout}s
}

# Get service external IP
get_service_ip() {
    local namespace=$1
    local service=$2
    
    kubectl get svc $service -n $namespace -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
}

# Apply kubectl file with error handling
apply_yaml() {
    local file=$1
    
    if [ ! -f "$file" ]; then
        log_error "File not found: $file"
        return 1
    fi
    
    log_info "Applying $file..."
    kubectl apply -f "$file"
}

# Export to .bashrc
add_to_bashrc() {
    local line=$1
    
    if ! grep -q "$line" ~/.bashrc; then
        echo "$line" >> ~/.bashrc
        log_info "Added to ~/.bashrc: $line"
    fi
}
