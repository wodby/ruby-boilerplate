# frozen_string_literal: true

require_relative "app"

use Rack::Head
use Rack::Static, urls: ["/assets"], root: "public"
run App.new
