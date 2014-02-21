FROM ubuntu:13.10

RUN apt-get update
RUN apt-get -y install nodejs
RUN apt-get -y install npm
RUN apt-get -y install git
RUN apt-get -y install rubygems
RUN gem install foreman
RUN mkdir /app

WORKDIR /app
ADD . /app

CMD ["foreman", "start", "web"]
