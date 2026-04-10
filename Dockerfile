# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim

# Install base dependencies (NO yarn, NO wkhtmltopdf here)
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  git \
  curl \
  nano \
  libvips \
  libjpeg-dev \
  libpng-dev \
  libfreetype6-dev \
  libxrender1 \
  libxext6 \
  libfontconfig1 \
  ca-certificates \
  gnupg \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js properly
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

# Install Yarn via corepack (CORRECT WAY)
RUN corepack enable && corepack prepare yarn@1.22.22 --activate

WORKDIR /app

ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV BUNDLE_PATH=/gems

RUN gem install bundler -v 2.4.17

COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

COPY . .

RUN yarn install --production

ENV SECRET_KEY_BASE=dummy
RUN bundle exec rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
