#!/bin/bash
if [ $# -eq 0 ]; then
  syntax
  exit 1
fi

DOCKER_FILE="$1"

if [ ! -r "$DOCKER_FILE" ]; then
  echo "Dockerfile $DOCKER_FILE does not exist"
  exit 1
fi

IMAGE=`sed -n -e "s/^ *# *IMAGE: *\([^ ]*\)/\1/p" $DOCKER_FILE`
if [ -z "$IMAGE" ]; then
  echo "Couldn't find mandatory IMAGE"
  echo
  syntax
  exit 1
fi

OPTIONS=`sed -n -e "s/^ *# *OPTIONS: *\([^ ]*\)/\1/p" $DOCKER_FILE`

# Generate the registry API url fom the docker image.
DOCKER_URL="https://"`echo $IMAGE | sed -e "s,^https*://,," -e "s,/\(.*\):\(.*\),/v2/\1/manifests/\2,"`
if [ `basename "$DOCKER_URL"` != "latest" ]; then
  echo "Checking if the docker image already exists..."
  curl -k -s -o /dev/null --fail -H 'Accept: application/vnd.docker.distribution.manifest.v2+json' "$DOCKER_URL"
  if [ $? -eq 0 ]; then
    echo "Image/tag $IMAGE already exists. Not allowing to overwrite"
    exit 1
  else
    echo "No image with this name and tag, no risk of overwriting"
  fi
else
  echo "Using 'latest' tag, overwrite check not needed"
fi

echo "Building docker image $IMAGE"

docker build --pull -t $IMAGE $OPTIONS $(dirname $DOCKER_FILE)
if [ $? -ne 0 ]; then
  echo "Error building docker image $IMAGE"
  exit 1
fi

echo "Finished building docker image $IMAGE"

if [ "$2" == "-p" ]; then
    echo "Publishing docker image $IMAGE"
    docker push $IMAGE
fi
