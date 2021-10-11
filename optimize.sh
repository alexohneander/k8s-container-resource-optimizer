# get namespaces from kubectl into array
NAMESPACES=$(kubectl get namespaces -o jsonpath='{.items[*].metadata.name}')

# check if namespace paramater is set
# if [ -z "$1" ]; then
#     $NAMESPACES = "$1"
# fi

echo "Checking following Namespaces: "
# loop through namespaces
for namespace in $NAMESPACES; do
    echo "Namespace: $namespace"
    
    # get pods from namespace
    PODS=$(kubectl get pods -n $namespace -o jsonpath='{.items[*].metadata.name}')
done