# Install helm chart for CSI Secret Storage Driver
resource "helm_release" "secret_storage_csi_driver" {
  depends_on = [null_resource.kubectl]
  chart      = "secrets-store-csi-driver"
  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  name       = "secrets-store-csi-driver"
  namespace  = local.kube_namespace
  #version    = "1.0.1"
  atomic     = true

  set {
    name  = "linux.tolerations[0].operator"
    value = "Exists"
  }

  set {
    name  = "linux.tolerations[0].effect"
    value = "NoSchedule"
  }

  set {
    name  = "syncSecret.enabled"
    value = "true"
  }
}

resource "kubectl_manifest" "csi-secrets-store-provider-aws-sa" {
  depends_on = [null_resource.kubectl]
    yaml_body = <<YAML
# https://kubernetes.io/docs/reference/access-authn-authz/rbac
apiVersion: v1
kind: ServiceAccount
metadata:
  name: csi-secrets-store-provider-aws
  namespace: kube-system

YAML  
}

resource "kubectl_manifest" "csi-secrets-store-provider-aws-cluster-role" {
depends_on = [null_resource.kubectl]  
yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: csi-secrets-store-provider-aws-cluster-role-${var.region}
rules:
- apiGroups: [""]
  resources: ["serviceaccounts/token"]
  verbs: ["create"]
- apiGroups: [""]
  resources: ["serviceaccounts"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get"]
- apiGroups: [""]
  resources: ["nodes"]
  verbs: ["get"]

YAML  
}

resource "kubectl_manifest" "csi-secrets-store-provider-aws-cluster-rolebinding" {
depends_on = [null_resource.kubectl]  
yaml_body = <<YAML
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: csi-secrets-store-provider-aws-cluster-rolebinding-${var.region}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: csi-secrets-store-provider-aws-cluster-role-${var.region}
subjects:
- kind: ServiceAccount
  name: csi-secrets-store-provider-aws
  namespace: kube-system
YAML  
}

resource "kubectl_manifest" "csi-secrets-store-provider-aws" {
depends_on = [null_resource.kubectl]  
yaml_body = <<YAML
apiVersion: apps/v1
kind: DaemonSet
metadata:
  namespace: kube-system
  name: csi-secrets-store-provider-aws
  labels:
    app: csi-secrets-store-provider-aws
spec:
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: csi-secrets-store-provider-aws
  template:
    metadata:
      labels:
        app: csi-secrets-store-provider-aws
    spec:
      serviceAccountName: csi-secrets-store-provider-aws
      hostNetwork: false
      containers:
        - name: provider-aws-installer
          image: public.ecr.aws/aws-secrets-manager/secrets-store-csi-driver-provider-aws:1.0.r2-42-ga2fd202-2023.03.03.20.03
          imagePullPolicy: Always
          args:
              - --provider-volume=/etc/kubernetes/secrets-store-csi-providers
          resources:
            requests:
              cpu: 50m
              memory: 100Mi
            limits:
              cpu: 50m
              memory: 100Mi
          securityContext:
            privileged: false
            allowPrivilegeEscalation: false
          volumeMounts:
            - mountPath: "/etc/kubernetes/secrets-store-csi-providers"
              name: providervol
            - name: mountpoint-dir
              mountPath: /var/lib/kubelet/pods
              mountPropagation: HostToContainer
      volumes:
        - name: providervol
          hostPath:
            path: "/etc/kubernetes/secrets-store-csi-providers"
        - name: mountpoint-dir
          hostPath:
            path: /var/lib/kubelet/pods
            type: DirectoryOrCreate
      nodeSelector:
        kubernetes.io/os: linux
YAML
}