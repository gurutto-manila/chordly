# syntax=docker/dockerfile:1

ARG RUBY_VERSION=3.4.5
FROM ruby:${RUBY_VERSION}-slim

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  yarn \
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
  wkhtmltopdf \
  && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Set environment
ENV RAILS_ENV=production
ENV RACK_ENV=production
ENV BUNDLE_PATH=/gems

# Install bundler
RUN gem install bundler -v 2.4.17

# Copy Gemfile first (for caching)
COPY Gemfile Gemfile.lock ./
RUN bundle install --without development test

# Copy app
COPY . .

# Install JS dependencies
RUN yarn install --production

# Precompile assets
ENV SECRET_KEY_BASE=dummy
RUN bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
