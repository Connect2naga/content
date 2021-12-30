#!/bin/bash

# remediation = none
yum install -y jq

kube_apipath="/kubernetes-api-resources"

mkdir -p "$kube_apipath/apis/apps/v1/daemonsets"

daemonsets_apipath="/apis/apps/v1/daemonsets?limit=500"

# This file assumes that we have 1 daemonsets & have the resource requests and limits
cat <<EOF > "$kube_apipath$daemonsets_apipath"
{
    "apiVersion": "v1",
    "items": [
        {
            "apiVersion": "apps/v1",
            "kind": "DaemonSet",
            "metadata": {
                "annotations": {
                    "deprecated.daemonset.template.generation": "1"
                },
                "creationTimestamp": "2021-12-30T10:03:47Z",
                "generation": 1,
                "labels": {
                    "k8s-app": "fluentd-logging"
                },
                "managedFields": [
                    {
                        "apiVersion": "apps/v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:metadata": {
                                "f:annotations": {
                                    ".": {},
                                    "f:deprecated.daemonset.template.generation": {}
                                },
                                "f:labels": {
                                    ".": {},
                                    "f:k8s-app": {}
                                }
                            },
                            "f:spec": {
                                "f:revisionHistoryLimit": {},
                                "f:selector": {},
                                "f:template": {
                                    "f:metadata": {
                                        "f:labels": {
                                            ".": {},
                                            "f:name": {}
                                        }
                                    },
                                    "f:spec": {
                                        "f:containers": {
                                            "k:{\"name\":\"fluentd-elasticsearch\"}": {
                                                ".": {},
                                                "f:image": {},
                                                "f:imagePullPolicy": {},
                                                "f:name": {},
                                                "f:resources": {
                                                    ".": {},
                                                    "f:limits": {
                                                        ".": {},
                                                        "f:cpu": {},
                                                        "f:memory": {}
                                                    },
                                                    "f:requests": {
                                                        ".": {},
                                                        "f:cpu": {},
                                                        "f:memory": {}
                                                    }
                                                },
                                                "f:terminationMessagePath": {},
                                                "f:terminationMessagePolicy": {},
                                                "f:volumeMounts": {
                                                    ".": {},
                                                    "k:{\"mountPath\":\"/var/lib/docker/containers\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {},
                                                        "f:readOnly": {}
                                                    },
                                                    "k:{\"mountPath\":\"/var/log\"}": {
                                                        ".": {},
                                                        "f:mountPath": {},
                                                        "f:name": {}
                                                    }
                                                }
                                            }
                                        },
                                        "f:dnsPolicy": {},
                                        "f:restartPolicy": {},
                                        "f:schedulerName": {},
                                        "f:securityContext": {},
                                        "f:terminationGracePeriodSeconds": {},
                                        "f:tolerations": {},
                                        "f:volumes": {
                                            ".": {},
                                            "k:{\"name\":\"varlibdockercontainers\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            },
                                            "k:{\"name\":\"varlog\"}": {
                                                ".": {},
                                                "f:hostPath": {
                                                    ".": {},
                                                    "f:path": {},
                                                    "f:type": {}
                                                },
                                                "f:name": {}
                                            }
                                        }
                                    }
                                },
                                "f:updateStrategy": {
                                    "f:rollingUpdate": {
                                        ".": {},
                                        "f:maxSurge": {},
                                        "f:maxUnavailable": {}
                                    },
                                    "f:type": {}
                                }
                            }
                        },
                        "manager": "kubectl-create",
                        "operation": "Update",
                        "time": "2021-12-30T10:03:47Z"
                    },
                    {
                        "apiVersion": "apps/v1",
                        "fieldsType": "FieldsV1",
                        "fieldsV1": {
                            "f:status": {
                                "f:currentNumberScheduled": {},
                                "f:desiredNumberScheduled": {},
                                "f:numberAvailable": {},
                                "f:numberReady": {},
                                "f:observedGeneration": {},
                                "f:updatedNumberScheduled": {}
                            }
                        },
                        "manager": "kube-controller-manager",
                        "operation": "Update",
                        "subresource": "status",
                        "time": "2021-12-30T10:03:50Z"
                    }
                ],
                "name": "fluentd-with-resource",
                "namespace": "kube-system",
                "resourceVersion": "68310",
                "uid": "cd79c924-3d9b-48cc-9c22-37d6821a8c91"
            },
            "spec": {
                "revisionHistoryLimit": 10,
                "selector": {
                    "matchLabels": {
                        "name": "fluentd-elasticsearch"
                    }
                },
                "template": {
                    "metadata": {
                        "creationTimestamp": null,
                        "labels": {
                            "name": "fluentd-elasticsearch"
                        }
                    },
                    "spec": {
                        "containers": [
                            {
                                "image": "quay.io/fluentd_elasticsearch/fluentd:v2.5.2",
                                "imagePullPolicy": "IfNotPresent",
                                "name": "fluentd-elasticsearch",
                                "resources": {
                                    "limits": {
                                        "cpu": "100m",
                                        "memory": "200Mi"
                                    },
                                    "requests": {
                                        "cpu": "100m",
                                        "memory": "200Mi"
                                    }
                                },
                                "terminationMessagePath": "/dev/termination-log",
                                "terminationMessagePolicy": "File",
                                "volumeMounts": [
                                    {
                                        "mountPath": "/var/log",
                                        "name": "varlog"
                                    },
                                    {
                                        "mountPath": "/var/lib/docker/containers",
                                        "name": "varlibdockercontainers",
                                        "readOnly": true
                                    }
                                ]
                            }
                        ],
                        "dnsPolicy": "ClusterFirst",
                        "restartPolicy": "Always",
                        "schedulerName": "default-scheduler",
                        "securityContext": {},
                        "terminationGracePeriodSeconds": 30,
                        "tolerations": [
                            {
                                "effect": "NoSchedule",
                                "key": "node-role.kubernetes.io/master",
                                "operator": "Exists"
                            }
                        ],
                        "volumes": [
                            {
                                "hostPath": {
                                    "path": "/var/log",
                                    "type": ""
                                },
                                "name": "varlog"
                            },
                            {
                                "hostPath": {
                                    "path": "/var/lib/docker/containers",
                                    "type": ""
                                },
                                "name": "varlibdockercontainers"
                            }
                        ]
                    }
                },
                "updateStrategy": {
                    "rollingUpdate": {
                        "maxSurge": 0,
                        "maxUnavailable": 1
                    },
                    "type": "RollingUpdate"
                }
            },
            "status": {
                "currentNumberScheduled": 6,
                "desiredNumberScheduled": 6,
                "numberAvailable": 6,
                "numberMisscheduled": 0,
                "numberReady": 6,
                "observedGeneration": 1,
                "updatedNumberScheduled": 6
            }
        }
    ],
    "kind": "List",
    "metadata": {
        "resourceVersion": "",
        "selfLink": ""
    }
}
EOF


jq_filter='[ .items[] | select( .spec.template.spec.containers[].resources.requests.cpu == null  or  .spec.template.spec.containers[].resources.requests.memory == null or .spec.template.spec.containers[].resources.limits.cpu == null  or  .spec.template.spec.containers[].resources.limits.memory == null )  | .metadata.name ]'

# Get file path. This will actually be read by the scan
filteredpath="$kube_apipath$daemonsets_apipath#$(echo -n "$daemonsets_apipath$jq_filter" | sha256sum | awk '{print $1}')"

# populate filtered path with jq-filtered result
jq "$jq_filter" "$kube_apipath$daemonsets_apipath" > "$filteredpath"