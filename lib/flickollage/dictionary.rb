module Flickollage
  class Dictionary
    MAX_DICT_LENGTH = 500_000

    COMMON_DICT_PATHS = %w(
      /usr/share/dict/words
      /usr/dict/words
    ).freeze

    class Error < ::Flickollage::Error; end

    attr_reader :words

    def initialize(path)
      @words = []
      File.foreach(path).with_index do |line, i|
        break if i >= MAX_DICT_LENGTH
        line = line.chop
        @words << line unless line.empty?
      end
      @words.shuffle!
    rescue Errno::ENOENT
      raise Error, 'Dictionary file not found'
    end

    def word
      @words.pop
    end

    class << self
      def default_dict_path
        COMMON_DICT_PATHS.find { |path| File.exist?(path) } || COMMON_DICT_PATHS.first
      end
    end
  end
end
