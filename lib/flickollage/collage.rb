module Flickollage
  class Collage
    include Logger
    class Error < ::Flickollage::Error; end

    attr_reader :dictionary
    attr_reader :words
    attr_reader :options
    attr_reader :images

    def initialize(words, options)
      @words = words
      @options = options

      init_dictionary
      load_images
    end

    private

    def init_dictionary
      @dictionary = Dictionary.new(options[:dict])
      @dictionary.append(words)
    rescue Flickollage::Dictionary::Error
      @dictionary = Dictionary.new(words)
    end

    def load_images
      @images = []
      options[:number].times do
        @images << load_image
      end
    end

    def load_image
      word = dictionary.pop
      not_enought_words unless word
      Image.new(word)
    rescue Flickollage::Image::Error
      load_image
    end

    def not_enought_words
      raise Flickollage::Error,
            'Not enought words. Please, specify more words or provide a bigger dictionary.'
    end
  end
end
