# frozen_string_literal: true

require "erb"
require "json"
require "rack"

class App
  TEMPLATE = ERB.new(File.read(File.join(__dir__, "views", "index.erb"))).freeze

  def call(environment)
    request = Rack::Request.new(environment)
    return method_not_allowed unless request.get? || request.head?

    case request.path_info
    when "/"
      html(TEMPLATE.result_with_hash(ruby_version: RUBY_VERSION, rack_version: Rack.release))
    when "/api/status"
      json({status: "ok", runtime: "Ruby #{RUBY_VERSION}", framework: "Rack #{Rack.release}"})
    when "/healthz"
      response(200, "text/plain; charset=utf-8", "ok\n")
    else
      json({detail: "Not found"}, status: 404)
    end
  end

  private

  def html(body)
    response(200, "text/html; charset=utf-8", body)
  end

  def json(payload, status: 200)
    response(status, "application/json; charset=utf-8", "#{JSON.generate(payload)}\n")
  end

  def method_not_allowed
    status, headers, body = json({detail: "Method not allowed"}, status: 405)
    headers["allow"] = "GET, HEAD"
    [status, headers, body]
  end

  def response(status, content_type, body)
    [
      status,
      {
        "content-type" => content_type,
        "content-length" => body.bytesize.to_s
      },
      [body]
    ]
  end
end
