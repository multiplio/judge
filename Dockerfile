FROM multipl/docker-proxify:latest

# install node + npm + yarn (+ curl)
RUN apt-get install -y gnupg curl \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -y && apt-get -y install nodejs npm yarn

RUN apt-get install vim -y

# copy setup and set as entrypoint
COPY ./setup /judge/setup
ENTRYPOINT ["/judge/setup/setup.sh"]

WORKDIR /app
