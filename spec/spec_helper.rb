$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'simplecov'
require 'timecop'

def fixture_path(*paths)
  fixture_dir = File.expand_path '../fixture', __FILE__
  File.join(fixture_dir, *paths)
end

SimpleCov.coverage_dir('target/coverage')

SimpleCov.start do
  add_filter 'spec'
  add_filter 'vendor'
end

require 'lzo'

RSpec.configure do |config|
  config.order = :random
end
