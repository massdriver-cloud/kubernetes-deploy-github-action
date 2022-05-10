# kubernetes-artifact-github-action

### Adding A GitHub Action Secret

This action expects an evironment variable called `ARTIFACT_KUBERNETES_CLUSTER` with the value set as a Massdriver _artifact_.
This is an example of the `kubernetes-cluster` artifact, downloaded from the Massdriver UI, as a data.json file.

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

GitHub environment variables don't work well with newlines, so we'll simply replace them with spaces. (`pbcopy` can be used to copy the newline-free environment variable to the clipboard.)

```
cat data.json | tr '\n' ' ' | pbcopy
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
