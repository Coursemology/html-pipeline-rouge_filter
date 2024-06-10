source "https://rubygems.org"

gem "html-pipeline", ">= 3"

# Specify your gem's dependencies in twemoji.gemspec
gemspec

group :development do
  gem "rake"
  gem "bundler"
  gem "pry"
  gem "rubocop", "0.49.1" # same as houndci/hound's Gemfile.lock
end

group :test do
  gem "minitest"

  gem "nokogiri", "~> 1.13"

  gem "minitest-focus", "~> 1.1"
  gem "rouge", "~> 4.1", require: false
end
