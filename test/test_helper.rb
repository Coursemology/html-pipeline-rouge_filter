# frozen_string_literal: true

require "bundler/setup"
require "html_pipeline"

require "minitest/autorun"
require "minitest/pride"
require "minitest/focus"

require "nokogiri"

module TestHelpers
  def assert_nothing_raised
    yield
  end
end

Minitest::Test.send(:include, TestHelpers)
