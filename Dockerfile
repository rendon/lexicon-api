# syntax = docker/dockerfile:1
FROM ubuntu:22.04 as base

SHELL ["/bin/bash", "-c"]

# Build dependencies
RUN apt-get update && \
    apt-get install -y \
        curl \
        gcc \
        make \
        libssl-dev \
        zlib1g-dev \
        tig \
        zip \
        unzip \
        libreadline-dev \
        locales locales-all

# Install packages needed to build gems
RUN apt-get install --no-install-recommends -y build-essential git libvips42 pkg-config libyaml-dev\
        libmysqlclient-dev

# Install packages needed for deployment
RUN apt-get install --no-install-recommends -y curl libsqlite3-0

RUN useradd rails --create-home --shell /bin/bash

################################################################################
USER rails:rails
################################################################################
# Get ruby installer
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
ENV PATH /home/rails/.rbenv/shims:/home/rails/.rbenv/bin:$PATH
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

# Set ruby version
ARG RUBY_VERSION=3.0.1

RUN rbenv install ${RUBY_VERSION}
RUN rbenv global ${RUBY_VERSION}

################################################################################
USER root
################################################################################


ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


# Rails app lives here
WORKDIR /home/rails/app
# Copy application code
COPY . .

# Run and own only the runtime files as a non-root user for security
#RUN chown -R rails:rails db log storage tmp
RUN chown -R rails:rails db log storage tmp vendor

RUN touch .ruby-version && mkdir .bundle/
RUN chown rails:rails .ruby-version .bundle

################################################################################
USER rails:rails
################################################################################
RUN rbenv local ${RUBY_VERSION}

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_WITHOUT="development"


FROM base as build


# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install
RUN rm -rf ~/.bundle/
RUN bundle exec bootsnap precompile --gemfile


# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

FROM build

# Start the server by default, this can be overwritten at runtime
EXPOSE 3001
CMD ["./bin/wait-for-it.sh", "-t", "30", "dbserver:3306", "--", "./bin/start-service.sh"]
