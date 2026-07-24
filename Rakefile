# frozen_string_literal: true

require "rake/testtask"

Rake::TestTask.new do |task|
  task.pattern = "test/**/*_test.rb"
end

desc "Check Ruby formatting and style"
task :standard do
  sh "bundle exec standardrb"
end

task default: [:test, :standard]
