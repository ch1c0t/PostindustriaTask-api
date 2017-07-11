FROM ruby:alpine

RUN apk update && apk add --no-cache build-base mariadb-dev

ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN gem i bundler -N; cd /app; bundle install
ADD . /app
WORKDIR /app

RUN chown -R nobody:nogroup /app

CMD ["ruby", "main.rb"]
