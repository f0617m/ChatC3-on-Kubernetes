FROM ruby:2.6.3
ENV LANG C.UTF-8

RUN apt-get update -qq && \
    apt-get install -y default-mysql-client \
    vim \
    dnsutils \
    build-essential \
    nodejs

RUN mkdir /webapp
WORKDIR /webapp

COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock

RUN gem install bundler
RUN bundle install

COPY . /webapp
