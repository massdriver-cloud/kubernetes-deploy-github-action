# kubernetes-artifact-github-action

### Example data.json

This is an example of the data.json file that is expected as an environment variable.

```json
{
  "authentication": {
    "cluster": {
      "certificate-authority-data": "base64-encoded-certificate-authority-data",
      "server": "https://118.118.118.118"
    },
    "user": {
      "token": "base64-encoded-token"
    }
  },
  "infrastructure": {
    ...specific infrastructure details
  }
}
```

### Example Usage

```yaml
name: Deploy to cluster
jobs:
  deploy_application:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Authenticate the Kubernetes Cluster
        id: kubernetes-authentication
        env:
          ARTIFACT_KUBERNETES_CLUSTER: ${{ secrets.ARTIFACT_KUBERNETES_CLUSTER }}
        uses: massdriver-cloud/kubernetes-authentication-github-action
      - name: Deploy the application
        run: |
          kubectl patch -p '{"spec": {"template": {"spec": {"containers": [{"name": "application", "image": "<<FULL_IMAGE_PATH"}]}}}}'
```
