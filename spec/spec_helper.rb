require 'bundler/setup'
require 'flickollage'

require 'dotenv'
Dotenv.load

# testing frameworks
require 'rspec'
require 'webmock/rspec'
require 'vcr'

Flickollage.init_logger

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock

  # Removes private data
  config.before_record do |i|
    i.request.headers.delete('Authorization')
  end
end
