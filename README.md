# kubernetes-deploy-github-action

### Prerequisites

A Massdriver-provisioned Kubernetes cluster.

### Adding A GitHub Action Secret

This action expects an evironment variable called `ARTIFACT_KUBERNETES_CLUSTER` with the value set as a Massdriver _artifact_. In the Massdriver UI, navigate to your artifacts and search for `kubernetes-cluster`. Make sure it's for the project and target you want to deploy to, then click the arrow in the _Actions_ column.

Massdriver supports downloading both a "raw" json artifact and a Kube Config yaml file. Click the arrow next to _Download Raw_ and you'll see the option for the Kube Config file. Select _Kube Config_ and then click the button to download the file.

Add this file as a _Repository Secret_ to the repository you want to run Continuous Deployment from. Most likey, this will be the same repository that your application lives, since that's the sha that the application image will be tagged with.

### Example Usage - AWS

See the `examples` folder for a build and push workflow as we support more cloud providers.

```yaml
name: Deploy to staging
on:
  push:
    branches:
      - main

jobs:
  build_and_push:
    name: Build and push
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v2

      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v1
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: us-west-2

      - name: Login to ECR
        id: ecr-Login
        uses: aws-actions/amazon-ecr-login@v1

      - name: Docker meta
        id: meta
        uses: docker/metadata-action@v3
        with:
          flavor: |
            latest=true
          images: <account-id>.dkr.ecr.us-west-2.amazonaws.com/${{ github.repository }}
          tags: |
            type=ref,event=branch
            type=sha
      - name: Build and push
        id: docker-build
        uses: docker/build-push-action@v2
        with:
          push: true
          tags: ${{ steps.meta.outputs.tags }}

  deploy_application:
    name: Deploy
    runs-on: ubuntu-latest
    # waits for the image to be build and pushed to ECR
    needs: build_and_push
    steps:
      - name: Deploy the application
        uses: massdriver-cloud/kubernetes-deploy-github-action@v1.1.0
        env:
          ARTIFACT_KUBERNETES_CLUSTER: ${{ secrets.ARTIFACT_KUBERNETES_CLUSTER_STAGING }}
          APPLICATION_NAME: infra-staging-myapp-884422
          IMAGE: <aws_account_id>.dkr.ecr.us-west-2.amazonaws.com/<organization>/<application>:${{ github.sha }}
```
