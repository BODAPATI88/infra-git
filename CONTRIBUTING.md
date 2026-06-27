# Contributing to infra-git

Thank you for your interest in contributing!

## Getting Started

### Prerequisites
- Linux host (Ubuntu 20.04+)
- kubectl >= 1.24
- Helm >= 3.12
- Git

### Setup

```bash
# Clone repository
git clone https://github.com/BODAPATI88/infra-git.git
cd infra-git

# Create feature branch
git checkout -b feature/your-feature-name
```

## Making Changes

### 1. Shell Script Guidelines

```bash
#!/bin/bash
# Always use set -e to exit on error
set -e

# Use meaningful variable names
NAMESPACE="argocd"
DEPLOYMENT="argocd-server"

# Add comments explaining complex logic
log_info "Installing ArgoCD..."

# Use functions for reusable code
wait_for_deployment() {
    local namespace=$1
    local deployment=$2
    kubectl wait --for=condition=available --timeout=300s deployment/$deployment -n $namespace
}
```

### 2. Test Your Changes

```bash
# Test shell script syntax
bash -n scripts/install-argocd.sh

# Run script in test environment
bash scripts/install-argocd.sh

# Verify installation
kubectl get deployment -n argocd
```

### 3. Update Documentation

- Update README.md with new features
- Add comments to scripts
- Document deployment steps
- Update troubleshooting guide

## Commit Message Guidelines

```
chore(scripts): update k3s installation script

Detailed explanation of changes.

Closes #123
```

## Pull Request Process

### Before Submitting
1. Test scripts in clean environment
2. Verify all components deploy correctly
3. Update documentation
4. Follow naming conventions
5. Add error handling

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] New installation script
- [ ] Bug fix
- [ ] Documentation update
- [ ] Dependency upgrade

## Testing
How have these changes been tested?

## Checklist
- [ ] Scripts tested
- [ ] Documentation updated
- [ ] Error handling added
- [ ] No hardcoded values

## Related Issues
Closes #123
```

## Best Practices

### Shell Script Standards

- Use `set -e` to exit on error
- Use functions for reusability
- Add meaningful comments
- Validate inputs
- Handle errors gracefully
- Use meaningful variable names

### Configuration Management

- Never commit secrets
- Use environment variables for configuration
- Document all configurable options
- Provide example configurations

### Testing

- Test in clean environment
- Verify all dependencies
- Check service status
- Validate networking
- Confirm monitoring is working

## Questions?

Feel free to open an issue or start a discussion!
