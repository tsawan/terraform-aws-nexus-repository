resource"helm_release""nxrm"{
depends_on = [module.dbcluster]    
name=var.helmcharts-release-name
repository="https://vswaminathan777.github.io/nexusrepositoryha"
chart="nxrm-ha-aws"
#chart="../nxrm_helm_charts/nxrm3-ha-repository/nxrm-aws-ha-helm"

/*
values=[
file("${path.module}/nginx-values.yaml")
]
*/

set{
name="statefulset.clusterRegion"
value=var.region
}

set{
name="statefulset.logsRegion"
value=var.region
}

set{
name="statefulset.container.image.repository"
value=var.nexus-repository-image
}

set{
name="statefulset.container.image.tag"
value=var.nexus-repository-version
}

set{
name="serviceAccount.name"
value=var.nexus-repository-sa-name
}

set{
name="serviceAccount.role"
value=aws_iam_role.eks_iamserviceaccount_app.arn
}

set{
name="ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
value=var.nexus-repository-lb-scheme
}

set{
name="ingress.annotations.alb\\.ingress\\.kubernetes\\.io/subnets"
value=join("\\,",module.vpc.public_subnets)
}

set{
name="secret.license.arn"
value=aws_secretsmanager_secret.license.arn
}

set{
name="secret.rds.arn"
value=aws_secretsmanager_secret.dbsecret.arn
}

set{
name="secret.adminpassword.arn"
value=aws_secretsmanager_secret.nxrmsecret.arn
}

set{
name="statefulset.container.resources.requests.cpu"
value=var.statefulset-container-resources["requests-cpu"]
}

set{
name="statefulset.container.resources.requests.memory"
value=var.statefulset-container-resources["requests-memory"]
}

set{
name="statefulset.container.resources.limits.cpu"
value=var.statefulset-container-resources["limits-cpu"]
}

set{
name="statefulset.container.resources.limits.memory"
value=var.statefulset-container-resources["limits-memory"]
}

set{
name="statefulset.container.env.nexusDBPort"
value=var.nexus-repository-db-port
}

set{
name="statefulset.replicaCount"
value=var.nexus-repository-instances-count
}

set{
name="fluentbit.enabled"
value=var.enable-cloud-watch
}

set{
name="namespaces.cloudwatchNs"
value=var.namespace-cloud-watch
}

set{
name="statefulset.containerPort"
value=var.nexus-repository-port
}

}
