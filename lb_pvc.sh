#!/bin/bash

cp /etc/unskript/unskript_ctl_config.yaml ${UNSKRIPT_SCRIPT_OUTPUT_DIR}/.

# Get the list of PVC names in your Kubernetes cluster
pvc_names=$(kubectl get pvc -o=jsonpath='{.items[*].metadata.name}')

# Loop through each PVC and print its name, capacity, and status
for pvc_name in $pvc_names; do
  pod_name=$(kubectl get pods --all-namespaces -o=json | jq -r '.items[] | select(.spec.volumes[].persistentVolumeClaim.claimName == "'$pvc_name'") | .metadata.name')
  if [ -n "$pod_name" ]; then
    echo "Checking PVC: $pvc_name"
    # Get the mount path for the PVC
    mount_path=$(kubectl get pods --all-namespaces -o=json | jq -r '.items[] | select(.metadata.name == "'$pod_name'") | .spec.containers[].volumeMounts[] | select(.name | test("'$pvc_name'")) | .mountPath')

    # Check the utilization using df
    kubectl exec -it $pod_name -- df -h $mount_path
    echo "-----------------------"
  fi
  pvc_info=$(kubectl describe pvc $pvc_name)
  capacity=$(echo "$pvc_info" | grep "Capacity" | awk '{print $2}')
  status=$(echo "$pvc_info" | grep "Status" | awk '{print $2}')
  echo "PVC Name: $pvc_name"
  echo "Capacity: $capacity"
  echo "Status: $status"
  echo "-----------------------"
done
