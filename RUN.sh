#!/bin/sh

# check if has required arguments
if [ -z "$1" ]; then
  echo "Usage: "
  echo " $ judge [image]"
  exit 0
fi

# parse input
REPO=$(echo $1 | awk -F '/' '{print $1}')
IMAGE=$(echo $1 | awk -F '/' '{print $2}')

if [ -z "$IMAGE" ]; then
  IMAGE=$REPO
  REPO=""
  echo "Running judge for: $IMAGE"
else
  echo "Running judge for: $REPO/$IMAGE"
fi

# find a free port to use for the image registry
read LOWERPORT UPPERPORT < /proc/sys/net/ipv4/ip_local_port_range
while :
do
  PORT="`shuf -i $LOWERPORT-$UPPERPORT -n 1`"
  ss -lpn | grep -q ":$PORT " || break
done

# create local image registry
REGISTRY_PORT=$PORT
REGISTRY_ID=$(
  docker run -d \
    -p $REGISTRY_PORT:5000 \
    --restart=always \
    --name judge-registry \
    registry:2
)
echo "Registry running at port: $PORT"
echo "Registry container id:    $REGISTRY_ID"

# copy image to registry
docker tag \
  $1 \
  localhost:$REGISTRY_PORT/$IMAGE

# start judge
echo "Starting up judge"
docker run --rm --privileged \
  --name judge \
  multipl/judge:latest

# kill registry
docker container kill $REGISTRY_ID
docker container remove $REGISTRY_ID
echo "Registry shutdown"
