echo ""
echo "[5/7] Kubernetes Validation"
echo "---------------------------------------"

if command -v kubectl &> /dev/null
then
    kubectl get pods -A

    echo ""
    echo "---------------------------------------"

    kubectl get svc -A
else
    echo "kubectl not installed on this node."
    echo "Run cluster validation from k8s-master."
fi
