ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE} AS builder

USER root
RUN apk add --no-cache --virtual .build-deps build-base

USER wodby
ARG COPY_FROM
COPY --chown=wodby:wodby ${COPY_FROM}/Gemfile ${COPY_FROM}/Gemfile.lock /usr/src/app/
RUN bundle install
COPY --chown=wodby:wodby ${COPY_FROM} /usr/src/app
RUN bin/ci && \
    bundle config set --local without "development test" && \
    bundle clean --force

FROM ${WODBY_BASE_IMAGE}

ENV BUNDLE_WITHOUT=development:test \
    PUMA_ENVIRONMENT=production \
    RACK_ENV=production

COPY --from=builder --chown=wodby:wodby /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=wodby:wodby /usr/src/app/Gemfile /usr/src/app/Gemfile
COPY --from=builder --chown=wodby:wodby /usr/src/app/Gemfile.lock /usr/src/app/Gemfile.lock
COPY --from=builder --chown=wodby:wodby /usr/src/app/app.rb /usr/src/app/app.rb
COPY --from=builder --chown=wodby:wodby /usr/src/app/config.ru /usr/src/app/config.ru
COPY --from=builder --chown=wodby:wodby /usr/src/app/public /usr/src/app/public
COPY --from=builder --chown=wodby:wodby /usr/src/app/views /usr/src/app/views
