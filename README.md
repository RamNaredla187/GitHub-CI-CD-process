# Docker Image contain postgres-pgvector-apache age databases
- This GitHub Actions workflow file automates the process of building and pushing a Docker image to Docker Hub when a change is pushed to the main branch of the repository. Let's break down the code step by step:
## Full Workflow Explanation
```bash
name: Publish Docker image

on:
  push:
    branches: ['main']
```
### 1. Workflow Name & Trigger
`name`: Publish Docker image: This defines the name of the workflow. In this case, it’s named "Publish Docker image."<br>
`on`: push: This specifies that the workflow will trigger whenever a push event occurs.<br>
`branches: ['main']`: The workflow will specifically trigger on a push to the main branch. This means if you push code changes to main, the workflow will execute.
#
```bash
jobs:
  push_to_registry:
    name: Push Docker image to Docker Hub
    runs-on: ubuntu-latest
```
### 2. Define Job and Environment
`jobs:`: This section defines the jobs that will be executed as part of the workflow.<br>
`push_to_registry:`: This is the name of the job. The job is responsible for pushing the Docker image to Docker Hub.<br>
`name`: Push Docker image to Docker Hub: The name for this job, which is "Push Docker image to Docker Hub."<br>
`runs-on`: ubuntu-latest: Specifies that the job will run on the latest version of the Ubuntu runner provided by GitHub Actions.<br>
#
```bash
    steps:
      - name: Check out the repo
        uses: actions/checkout@v3
```
### 3. Step 1: Checkout the Repository
`steps:`: Defines the sequence of steps to execute within the job.<br>
`name`: Check out the repo: The name of this step, which checks out the repository code to the runner.<br>
`uses: actions/checkout@v3`: This uses the actions/checkout action (version v3) to pull the latest code from the repository so that subsequent steps can access it. Without this step, the runner wouldn’t have the source code.<br>
#
```bash
      - name: Log in to Docker Hub
        uses: docker/login-action@f054a8b539a109f9f41c372932f1ae047eff08c9
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}
```
### 4. Step 2: Log in to Docker Hub
`name`: Log in to Docker Hub: The name of the step, which logs into Docker Hub.<br>
`uses: docker/login-action@f054a8b539a109f9f41c372932f1ae047eff08c9`: This action (docker/login-action) is used to authenticate the workflow with Docker Hub (or any other Docker registry). It uses a specific commit version (identified by the commit hash) to ensure a consistent version of the action is used.<br>
`with:`: This section provides input values to the action:<br>
- `username: ${{ secrets.DOCKER_USERNAME }}`: The Docker Hub username is stored in the GitHub secrets (a secure storage for sensitive information in GitHub) to avoid exposing it in the code.<br>
- `password: ${{ secrets.DOCKER_PASSWORD }}`: The Docker Hub password or token is also securely stored in the GitHub secrets.
#
```bash
      - name: Extract metadata (tags, labels) for Docker
        id: meta
        uses: docker/metadata-action@98669ae865ea3cffbcbaa878cf57c20bbf1c6c38
        with:
          images: rams4001/image-mysql-pgvector-apacheage
```
### 5. Step 3: Extract Metadata for Docker
`name`: Extract metadata (tags, labels) for Docker: This step extracts metadata for the Docker image, such as tags and labels.<br>
`id: meta`: The id assigned to this step. It will be used to reference the outputs of this step in later steps.<br>
`uses: docker/metadata-action@98669ae865ea3cffbcbaa878cf57c20bbf1c6c38`: This action (docker/metadata-action) is used to automatically generate metadata for the Docker image. It pulls information like version tags (e.g., latest, 1.0.0) based on the repository or tags in the code.<br>
`with:`:
- `images: rams4001/image-mysql-pgvector-apacheage`: This specifies the name of the Docker image, which in this case is rams4001/image-mysql-pgvector-apacheage. The action will use this image name to generate the appropriate tags (e.g., version tags) and labels.
#
```bash
      - name: Build and push Docker image
        uses: docker/build-push-action@ad44023a93711e3deb337508980b4b5e9bcdc5dc
        with:
          context: .
          push: true
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
```
### 6. Step 4: Build and Push Docker Image
`name: Build and push Docker image`: The name of this step, which is responsible for building and pushing the Docker image.<br>
`uses: docker/build-push-action@ad44023a93711e3deb337508980b4b5e9bcdc5dc`: This action (docker/build-push-action) is used to build and push Docker images. It uses a specific commit ID to ensure the correct version of the action is used.<br>
`with:`: Defines the parameters for the action:<br>
- `context: .`: The build context is the root directory (.), which tells Docker to look in the current directory for the Dockerfile and build context files.<br>
- `push: true`: This tells the action to push the built Docker image to Docker Hub after building it.<br>
- `tags: ${{ steps.meta.outputs.tags }}`: This sets the tags for the Docker image. It pulls the tags output by the previous metadata-action step, which will include version or tag information for the image (e.g., latest, or a specific version).<br>
- `labels: ${{ steps.meta.outputs.labels }}`: Similarly, this sets the labels for the image. Labels are key-value pairs that can be used to add metadata to the Docker image, making it easier to identify and manage.
#
## Summary of the Workflow Steps:
`1.Trigger`: The workflow is triggered on a push to the main branch.<br>
` 2.Checkout code`: It checks out the repository code so it can be used in subsequent steps.<br>
`3.Docker login`: Logs into Docker Hub using stored credentials in GitHub Secrets.<br>
`4.Extract metadata`: Retrieves metadata like tags and labels for the Docker image.<br>
`5.Build and push Docker image`: Builds the Docker image and pushes it to Docker Hub, using the generated metadata (tags, labels).<br>
### Purpose of the Workflow:
- This workflow automates the process of building and pushing a Docker image to Docker Hub whenever new changes are pushed to the main branch. It ensures the Docker image is always up to date on Docker Hub and that proper metadata (tags, labels) are applied to the image.
