#!/bin/bash
set -e

REGISTRY=$1
USERNAME=$2
PASSWORD=$3
IMAGE_NAME=$4
TAG=${5:-latest}

IMAGE="$REGISTRY/$IMAGE_NAME:$TAG"
SHA_IMAGE="$REGISTRY/$IMAGE_NAME:${GITHUB_SHA}"

echo "$PASSWORD" | docker login $REGISTRY -u $USERNAME --password-stdin

cp "$(dirname "$0")/Dockerfile.react" ./React-Frontend/Dockerfile.react

docker build -t $IMAGE -t $SHA_IMAGE \
  -f ./React-Frontend/Dockerfile.react \
  ./React-Frontend

docker push $IMAGE
docker push $SHA_IMAGE

echo "image_name=$SHA_IMAGE" >> $GITHUB_OUTPUT
echo "push_status=success" >> $GITHUB_OUTPUT

