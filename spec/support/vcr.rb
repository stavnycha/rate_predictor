require 'webmock/rspec'
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.ignore_localhost = true
  config.hook_into :webmock
  config.configure_rspec_metadata!
end
