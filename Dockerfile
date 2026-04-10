# syntax=docker/dockerfile:1
FROM ruby:3.4.5-slim

# Install system dependencies
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
  libyaml-dev \
  pkg-config \
  && rm -rf /var/lib/apt/lists/*

# Install Node.js (needed for Rails assets)
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - && \
    apt-get install -y nodejs

# Enable Yarn via corepack (modern way)
RUN corepack enable && corepack prepare yarn@1.22.22 --activate

# Set working directory
WORKDIR /app

# Install bundler
RUN gem install bundler -v 2.4.17

# Copy gem files
COPY Gemfile Gemfile.lock ./

# Fix deprecated bundler flag
RUN bundle config set --local without 'development test' && \
    bundle install

# Copy app
COPY . .

# Precompile assets
RUN RAILS_ENV=production bundle exec rails assets:precompile

# Expose port
EXPOSE 3000

# Start Rails
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
