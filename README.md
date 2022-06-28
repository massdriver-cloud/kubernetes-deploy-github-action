# kubernetes-artifact-github-action

### Prerequisites

A Massdriver-provisioned Kubernetes cluster.

### Adding A GitHub Action Secret

This action expects an evironment variable called `ARTIFACT_KUBERNETES_CLUSTER` with the value set as a Massdriver _artifact_. In the Massdriver UI, navigate to your artifacts and search for `kubernetes-cluster`. Make sure it's for the project and target you want to deploy to, then click the arrow in the _Actions_ column.

Massdriver supports downloading both a "raw" json artifact and a Kube Config yaml file. Click the arrow next to _Download Raw_ and you'll see the option for the Kube Config file. Select _Kube Config_ and then click the button to download the file.

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
      imageTag:
        description: 'Application image tag'
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
          kubectl patch -p '{"spec": {"template": {"spec": {"containers": [{"name": "application", "image": "${{ secrets.APPLICATION_IMAGE_REPOSITORY }}:${{ github.event.inputs.imageTag }}"}]}}}}'
```
