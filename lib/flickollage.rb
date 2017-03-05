require 'flickraw'

module Flickollage
  class Error < StandardError; end
  class << self
    attr_accessor :config
  end
end

require 'flickollage/dictionary.rb'
require 'flickollage/cli.rb'
