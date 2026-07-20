# frozen_string_literal: true

require "json"

application = lambda do |environment|
  case environment.fetch("PATH_INFO", "/")
  when "/"
    body = JSON.generate(message: "Hello from Wodby Ruby") << "\n"
    [200, { "content-type" => "application/json", "content-length" => body.bytesize.to_s }, [body]]
  when "/healthz"
    body = "ok\n"
    [200, { "content-type" => "text/plain; charset=utf-8", "content-length" => body.bytesize.to_s }, [body]]
  else
    body = JSON.generate(detail: "Not found") << "\n"
    [404, { "content-type" => "application/json", "content-length" => body.bytesize.to_s }, [body]]
  end
end

run application
