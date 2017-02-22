FROM ruby:alpine

RUN mkdir -p /app/
WORKDIR /app/

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install --path=vendor/bundle

ADD . /app/

RUN bundle exec clockwork lab-cleaner-checker.rb
