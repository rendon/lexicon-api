# syntax = docker/dockerfile:1
FROM rendon/ruby:latest AS base

USER root
RUN apt install -y libmysqlclient-dev

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

# admin app lives here
WORKDIR /home/admin/app
# Copy application code
COPY . .

# Run and own only the runtime files as a non-root user for security
RUN chown -R admin:admin db log storage tmp vendor

RUN touch .ruby-version && mkdir .bundle/
RUN chown admin:admin .ruby-version .bundle

USER admin:admin

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
