require 'simplecov'
SimpleCov.start

require 'webmock/rspec'
require_relative 'fake_app'

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:any, /fake-app.com/).to_rack(FakeApp)
  end
end
