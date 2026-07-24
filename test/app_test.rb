# frozen_string_literal: true

require "minitest/autorun"
require "rack/builder"
require "rack/lint"
require "rack/mock"

APP = Rack::Lint.new(Rack::Builder.parse_file(File.expand_path("../config.ru", __dir__)))

class AppTest < Minitest::Test
  def setup
    @client = Rack::MockRequest.new(APP)
  end

  def test_index
    response = @client.get("/")

    assert_equal 200, response.status
    assert_includes response.content_type, "text/html"
    assert_includes response.body, "Your Ruby app is running"
  end

  def test_static_asset
    response = @client.get("/assets/styles.css")

    assert_equal 200, response.status
    assert_includes response.content_type, "text/css"
  end

  def test_status
    response = @client.get("/api/status")

    assert_equal 200, response.status
    assert_equal "ok", JSON.parse(response.body).fetch("status")
  end

  def test_health
    response = @client.get("/healthz")

    assert_equal 200, response.status
    assert_equal "ok\n", response.body
  end

  def test_not_found
    response = @client.get("/missing")

    assert_equal 404, response.status
  end

  def test_method_not_allowed
    response = @client.post("/")

    assert_equal 405, response.status
    assert_equal "GET, HEAD", response["allow"]
  end

  def test_head
    response = @client.head("/")

    assert_equal 200, response.status
    assert_empty response.body
  end
end
