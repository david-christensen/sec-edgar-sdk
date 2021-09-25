require 'pry'
require 'active_support/time'

require_relative '../lib/sec-edgar-sdk'

require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    record: :once,
    match_requests_on: %i[method uri body]
  }
end
