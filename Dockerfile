ARG RUBY_VERSION=2.7.0

FROM ruby:${RUBY_VERSION}-slim

RUN apt-get update
RUN apt-get install -y git make gcc

COPY . /decouplio

WORKDIR /decouplio

RUN bundle check || bundle install
