ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE} AS builder

USER root
RUN apk add --no-cache --virtual .build-deps build-base

USER wodby
ARG COPY_FROM
COPY --chown=wodby:wodby ${COPY_FROM}/Gemfile ${COPY_FROM}/Gemfile.lock /usr/src/app/
RUN bundle install
COPY --chown=wodby:wodby ${COPY_FROM} /usr/src/app

FROM ${WODBY_BASE_IMAGE}
COPY --from=builder --chown=wodby:wodby /usr/local/bundle /usr/local/bundle
COPY --from=builder --chown=wodby:wodby /usr/src/app /usr/src/app
