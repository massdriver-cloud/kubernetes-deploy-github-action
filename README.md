# kubernetes-artifact-github-action

### Prerequisites

A Massdriver-provisioned Kubernetes cluster.

### Adding A GitHub Action Secret

This action expects an evironment variable called `ARTIFACT_KUBERNETES_CLUSTER` with the value set as a Massdriver _artifact_. In the Massdriver UI, navigate to your artifacts and search for `kubernetes-cluster`. Make sure it's for the project and target you want to deploy to, then click the arrow in the _Actions_ column.

Massdriver supports downloading both a "raw" json artifact and a Kube Config yaml file. Click the arrow next to _Download Raw_ and you'll see the option for the Kube Config file. Select _Kube Config_ and then click the button to download the file.

### Example Usage

```yaml
name: Deploy to cluster
on:
  push:
    branches:
      - main

jobs:
  deploy_application:
    name: Deploy
    runs-on: ubuntu-latest
    steps:
      - name: Deploy the application
        uses: massdriver-cloud/kubernetes-authentication-github-action@v0.1.0
        env:
          KUBECONFIG: ${{ secrets.ARTIFACT_KUBERNETES_CLUSTER }}
        with:
          application_name: infra-staging-myapp-884422
          image: <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/<organization>/<application>:${{ github.sha }}
```
