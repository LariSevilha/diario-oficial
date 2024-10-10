FROM ruby:3.2.0-slim-bullseye

WORKDIR /app

ARG UID=1000
ARG GID=1000

RUN bash -c "set -o pipefail && apt-get update \
  && apt-get install -y --no-install-recommends \
  build-essential \
  curl \
  git \
  libpq-dev \
  libvips42 \
  libjpeg62-turbo-dev \
  openssh-client \
  && curl -sSL https://deb.nodesource.com/setup_18.x | bash - \
  && curl -sSL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update && apt-get install -y --no-install-recommends nodejs yarn \
  && rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man \
  && apt-get clean \
  && groupadd -g \"${GID}\" agenciaw3 \
  && useradd --create-home --no-log-init -u \"${UID}\" -g \"${GID}\" agenciaw3 \
  && chown agenciaw3:agenciaw3 -R /app /usr/local/bundle"

USER agenciaw3

COPY --chown=agenciaw3:agenciaw3 Gemfile* ./
RUN bundle install

COPY --chown=agenciaw3:agenciaw3 package.json *yarn* ./
RUN yarn install

ARG RAILS_ENV="production"
ARG NODE_ENV="production"
ENV RAILS_ENV="${RAILS_ENV}" \
    NODE_ENV="${NODE_ENV}" \
    USER="agenciaw3" \
    TZ=America/Campo_Grande

COPY --chown=agenciaw3:agenciaw3 . .
