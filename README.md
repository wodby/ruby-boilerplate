# Minimal Ruby boilerplate

Minimal Rack application for the [Wodby Ruby service](https://github.com/wodby/service-ruby) and [Ruby stack](https://github.com/wodby/stack-ruby).

The application runs with Puma and includes a Wodby CI pipeline.

## Local development

```shell
bundle install
bundle exec puma -p 8080
```

Open http://localhost:8080. A health endpoint is available at `/healthz`.
