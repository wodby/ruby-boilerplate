# Ruby starter for Wodby

A small, production-oriented Rack application for the [Wodby Ruby service](https://github.com/wodby/service-ruby) and [Ruby stack](https://github.com/wodby/stack-ruby).

It demonstrates:

- a testable Rack application and middleware stack
- an ERB landing page and static assets
- JSON, health, not-found, and method-not-allowed responses
- Puma production serving
- Minitest, Rack::Lint, Standard Ruby, and Wodby CI

## Local development

```shell
bundle install
bundle exec rake
bundle exec puma -p 8080
```

Open <http://localhost:8080>. Useful endpoints are:

- `/` — the ERB landing page
- `/api/status` — a JSON response example
- `/healthz` — the deployment health endpoint

## Project structure

- `app.rb` contains the Rack application and response handling.
- `config.ru` composes middleware and starts the application.
- `views/` and `public/` contain the landing page and stylesheet.
- `test/` exercises the complete Rack stack through `Rack::MockRequest`.

Add product routes to `App#call`, or replace its small dispatcher with the
framework of your choice while keeping the production server and deployment
workflow.

Wodby runs Puma in the `production` environment and exposes the application on
port 8080. PostgreSQL, Valkey, and SMTP links are optional and become available
through the documented Wodby environment variables when enabled.
