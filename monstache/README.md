# monstache

![Version: 1.0.0](https://img.shields.io/badge/Version-1.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: rel6](https://img.shields.io/badge/AppVersion-rel6-informational?style=flat-square)

A Helm chart for deploying Monstache on Kubernetes

## How To

### Configure MongoDB Source and ElasticSearch Target

At very minimum, specify the MongoDB source and ElasticSearch target under `config` key.

```yaml
config:
  change-stream-namespaces:
    - "elasticsearch-master"
  config-database-name: "mongodb"
```

### Configure Mapping

If you need to customize how Monstache do mapping, specify the configuration under `mapping` key. The expected values is array of object, with all the key and value will be transformed into TOML configuration. To learn more, please check [the complete documentation](https://rwynn.github.io/monstache-site/advanced/#index-mapping)
```yaml
- namespace: target-namespace
  index: target-index
```

### Configure Middleware

To supply Monstache [middleware](https://rwynn.github.io/monstache-site/advanced/#middleware), specify the code under `script` key. It expecting an array of object with `namespace` and `script` key.

```yaml
script:
  - namespace: target-namespace
    script:
      lang: js
      code: |
        var counter = 1;
        module.exports = function(doc) {
            doc.foo += "test" + counter;
            counter++;
            return doc;
        }
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| config | object | `{"change-stream-namespaces":["elasticsearch-master"],"config-database-name":"mongodb"}` | Monstache related [global](https://rwynn.github.io/monstache-site/start/#usage) config |
| env | object | `{}` | Environment Variables to be injected |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"rwynn/monstache"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| mapping | list | `[]` | Monstache [mapping](https://rwynn.github.io/monstache-site/advanced/#index-mapping) configuration in form of array as follows ``` - namespace: target-namespace   index: target-index ``` |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| script | list | `[]` | Monstache [scripts](https://rwynn.github.io/monstache-site/advanced/#middleware) configuration. in form of array with the following format ``` - namespace: target-namespace   script:     lang: js/go     code: |       multiline transform code ``` |
| securityContext | object | `{}` |  |
| service.port | int | `80` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| worker.count | int | `0` | Number of worker to spawn |
| worker.enabled | bool | `false` | Enable worker mode. If enabled, the deployment will be changed into statefulset. |