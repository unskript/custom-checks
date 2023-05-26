from __future__ import annotations

#
# Copyright (c) 2022 unSkript.com
# All rights reserved.
#
from pydantic import BaseModel, Field



from pydantic import BaseModel, Field


class InputSchema(BaseModel):
    kubectl_command: str = Field(
        ...,
        description='kubectl command eg "kubectl get pods --all-namespaces"',
        title='Kubectl Command',
    )




def custom_k8s_get_all_ns_printer(output):
    if output is None:
        return
    print(output)


def custom_k8s_get_all_ns(handle, kubectl_command: str) -> str:
    """custom_k8s_get_all_ns executes the given kubectl command on the pod

        :type handle: object
        :param handle: Object returned from the Task validate method

        :type kubectl_command: str
        :param kubectl_command: The Actual kubectl command, like kubectl get ns, etc..

        :rtype: String, Output of the command in python string format or Empty String in case of Error.
    """
    if handle.client_side_validation != True:
        print(f"K8S Connector is invalid: {handle}")
        return str()

    result = handle.run_native_cmd(kubectl_command)
    if result is None or hasattr(result, "stderr") is False or result.stderr is None:
        print(
            f"Error while executing command ({kubectl_command}): {result.stderr}")
        return str()

    return result.stdout


