#!/bin/bash

# remediation = none
yum install -y jq

kube_apipath="/kubernetes-api-resources"

mkdir -p "$kube_apipath/apis/apps/v1/statefulsets"

statefulset_apipath="/apis/apps/v1/statefulsets?limit=500"

# This file assumes that we have 1 statefulsets & dont have the resource requests and limits
cat <<EOF > "$kube_apipath$statefulset_apipath"
{
    "apiVersion": "apps/v1",
    "kind": "StatefulSet",
    "metadata": {
        "creationTimestamp": "2021-12-30T09:26:47Z",
        "generation": 1,
        "labels": {
            "app": "nginx"
        },
        "managedFields": [
            {
                "apiVersion": "apps/v1",
                "fieldsType": "FieldsV1",
                "fieldsV1": {
                    "f:status": {
                        "f:collisionCount": {},
                        "f:currentReplicas": {},
                        "f:currentRevision": {},
                        "f:observedGeneration": {},
                        "f:replicas": {},
                        "f:updateRevision": {},
                        "f:updatedReplicas": {}
                    }
                },
                "manager": "kube-controller-manager",
                "operation": "Update",
                "subresource": "status",
                "time": "2021-12-30T09:26:47Z"
            },
            {
                "apiVersion": "apps/v1",
                "fieldsType": "FieldsV1",
                "fieldsV1": {
                    "f:metadata": {
                        "f:labels": {
                            ".": {},
                            "f:app": {}
                        }
                    },
                    "f:spec": {
                        "f:podManagementPolicy": {},
                        "f:replicas": {},
                        "f:revisionHistoryLimit": {},
                        "f:selector": {},
                        "f:serviceName": {},
                        "f:template": {
                            "f:metadata": {
                                "f:labels": {
                                    ".": {},
                                    "f:app": {}
                                }
                            },
                            "f:spec": {
                                "f:containers": {
                                    "k:{\"name\":\"nginx\"}": {
                                        ".": {},
                                        "f:image": {},
                                        "f:imagePullPolicy": {},
                                        "f:name": {},
                                        "f:ports": {
                                            ".": {},
                                            "k:{\"containerPort\":80,\"protocol\":\"TCP\"}": {
                                                ".": {},
                                                "f:containerPort": {},
                                                "f:name": {},
                                                "f:protocol": {}
                                            }
                                        },
                                        "f:resources": {},
                                        "f:terminationMessagePath": {},
                                        "f:terminationMessagePolicy": {},
                                        "f:volumeMounts": {
                                            ".": {},
                                            "k:{\"mountPath\":\"/usr/share/nginx/html\"}": {
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
                                "f:terminationGracePeriodSeconds": {}
                            }
                        },
                        "f:updateStrategy": {
                            "f:rollingUpdate": {
                                ".": {},
                                "f:partition": {}
                            },
                            "f:type": {}
                        },
                        "f:volumeClaimTemplates": {}
                    }
                },
                "manager": "kubectl-create",
                "operation": "Update",
                "time": "2021-12-30T09:26:47Z"
            }
        ],
        "name": "statefulset-without-resource",
        "namespace": "default",
        "resourceVersion": "50061",
        "uid": "db840d4a-776b-421a-8fdd-572da583beac"
    },
    "spec": {
        "podManagementPolicy": "OrderedReady",
        "replicas": 14,
        "revisionHistoryLimit": 10,
        "selector": {
            "matchLabels": {
                "app": "nginx"
            }
        },
        "serviceName": "nginx",
        "template": {
            "metadata": {
                "creationTimestamp": null,
                "labels": {
                    "app": "nginx"
                }
            },
            "spec": {
                "containers": [
                    {
                        "image": "k8s.gcr.io/nginx-slim:0.8",
                        "imagePullPolicy": "IfNotPresent",
                        "name": "nginx",
                        "ports": [
                            {
                                "containerPort": 80,
                                "name": "web",
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {},
                        "terminationMessagePath": "/dev/termination-log",
                        "terminationMessagePolicy": "File",
                        "volumeMounts": [
                            {
                                "mountPath": "/usr/share/nginx/html",
                                "name": "www"
                            }
                        ]
                    }
                ],
                "dnsPolicy": "ClusterFirst",
                "restartPolicy": "Always",
                "schedulerName": "default-scheduler",
                "securityContext": {},
                "terminationGracePeriodSeconds": 30
            }
        },
        "updateStrategy": {
            "rollingUpdate": {
                "partition": 0
            },
            "type": "RollingUpdate"
        },
        "volumeClaimTemplates": [
            {
                "apiVersion": "v1",
                "kind": "PersistentVolumeClaim",
                "metadata": {
                    "creationTimestamp": null,
                    "name": "www"
                },
                "spec": {
                    "accessModes": [
                        "ReadWriteOnce"
                    ],
                    "resources": {
                        "requests": {
                            "storage": "1Gi"
                        }
                    },
                    "storageClassName": "thin-disk",
                    "volumeMode": "Filesystem"
                },
                "status": {
                    "phase": "Pending"
                }
            }
        ]
    },
    "status": {
        "collisionCount": 0,
        "currentReplicas": 1,
        "currentRevision": "statefulset-without-resource-b46f789c4",
        "observedGeneration": 1,
        "replicas": 1,
        "updateRevision": "statefulset-without-resource-b46f789c4",
        "updatedReplicas": 1
    }
}
EOF


jq_filter='[ .items[] | select( .spec.template.spec.containers[].resources.requests.cpu == null  or  .spec.template.spec.containers[].resources.requests.memory == null or .spec.template.spec.containers[].resources.limits.cpu == null  or  .spec.template.spec.containers[].resources.limits.memory == null )  | .metadata.name ]'

# Get file path. This will actually be read by the scan
filteredpath="$kube_apipath$statefulset_apipath#$(echo -n "$statefulset_apipath$jq_filter" | sha256sum | awk '{print $1}')"

# populate filtered path with jq-filtered result
jq "$jq_filter" "$kube_apipath$statefulset_apipath" > "$filteredpath"