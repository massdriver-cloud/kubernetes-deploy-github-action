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
  "infrastructure": {}
}
```

### Example Usage

```yaml
name: Deploy to cluster
on:
   workflow_dispatch:
     inputs:
       imagePath:
         description: 'Application image path'
         required: true
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
        env:
          KUBECONFIG: ${{ steps.kubernetes-authentication.outputs.kube_config }}
        run: |
          kubectl patch -p '{"spec": {"template": {"spec": {"containers": [{"name": "application", "image": "${{ github.event.inputs.imagePath }}"}]}}}}'
```
