#!/bin/bash

set -e

IMAGE=cmr1/yii-example
CLUSTER=bowtie-v1-test
SERVICE=yii
TASK_DEFINITION=yii
BRANCH_TARGETS=()

should_deploy_branch() {
  for i in "${BRANCH_TARGETS[@]}"; do
    if [[ "$1" == "$i" ]]; then
      return 0
    fi
  done

  return 1
}

push() {
  # Get the tag from argument to this function
  TAG="${1:-latest}"

  # Build image with release tag
  echo "Building tagged release '$TAG'"
  docker build -t $IMAGE:$TAG .

  # Authenticate with DockerHub
  echo "Authenticating with DockerHub"
  docker login -u="$DOCKER_HUB_USERNAME" -p="$DOCKER_HUB_PASSWORD" 
  
  # Tag the Docker image
  echo "Tagging for release '$IMAGE:$TAG'"
  docker tag $IMAGE:$TAG $IMAGE:$TAG
  
  # Push the tagged image
  echo "Pushing tagged release '$TAG'"
  docker push $IMAGE:$TAG
}

deploy() {
  echo "Update ECS Anchor Task Definition..."
  aws ecs register-task-definition --cli-input-json file://task-definition.json

  echo "Update ECS Anchor Service..."
  aws ecs update-service --cluster $CLUSTER --service $SERVICE --task-definition $TASK_DEFINITION
}

if [ ! -z "$TRAVIS_TAG" ]; then
  push $TRAVIS_TAG
elif [ "$TRAVIS_BRANCH" == "master" ]; then
  push latest && deploy
elif should_deploy_branch $TRAVIS_BRANCH; then
  push $TRAVIS_BRANCH
fi

echo "Finished!"
