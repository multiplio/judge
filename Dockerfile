FROM jrandall/docker-proxify

# install node + npm + yarn (+ curl)
RUN apt-get update \
 && apt-get install -yq nodejs npm curl \
 && npm install --global yarn

