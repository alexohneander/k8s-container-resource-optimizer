# get namespaces from kubectl into array
NAMESPACES=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# check if namespace paramater is set
# if [ -z "$1" ]; then
#     $NAMESPACES = "$1"
# fi

echo "Checking following Namespaces: "
# loop through namespaces
for namespace in $NAMESPACES; do

    # get pods from namespace
    PODS=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')

    # if PODS is empty, skip namespace
    if [ -z "$PODS" ]; then
        echo "No Pods found in namespace $namespace"
        continue
    fi

    echo "Checking Pods in namespace $namespace"
    for pod in $PODS; do

        # if pod has no limits or request, skip pod
        if [ -z "$(kubectl describe pod $pod -n $namespace | grep Limits)" ] || [ -z "$(kubectl describe pod $pod -n $namespace | grep Requests)" ]; then
            continue
        fi

        # get resource requests/limits from pod
        REQUESTS=$(kubectl get pod $pod -n $namespace -o jsonpath='{.spec.containers[*].resources.requests}')
        LIMITS=$(kubectl get pod $pod -n $namespace -o jsonpath='{.spec.containers[*].resources.limits}')
        
        echo " "
        echo "Pod: $pod"
        echo "-----------------------"
        echo "Requests: $REQUESTS"
        echo "Limits: $LIMITS"
        
    done
done