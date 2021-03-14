FROM arm32v7/ruby:3.0.0-alpine
LABEL maintainer="georg@ledermann.dev"

WORKDIR /renault-collector

COPY Gemfile* /renault-collector/
RUN bundle config --local frozen 1 && \
    bundle install -j4 --retry 3

COPY . /renault-collector/
