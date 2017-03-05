module Flickollage
  class Dictionary
    MAX_DICT_LENGTH = 500_000

    attr_reader :words

    def initialize(path)
      @words = []
      File.foreach(path).with_index do |line, i|
        break if i >= MAX_DICT_LENGTH
        line = line.chop
        @words << line unless line.empty?
      end
      @words.shuffle!
    end

    def word
      @words.pop
    end
  end
end
