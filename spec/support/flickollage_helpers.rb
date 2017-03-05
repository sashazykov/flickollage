module Flickollage
  module SpecHelpers
    def fixture_file_path(file_name)
      File.join(__dir__, '..', 'fixtures', file_name)
    end
  end
end

RSpec.configure do |config|
  config.include Flickollage::SpecHelpers
end
