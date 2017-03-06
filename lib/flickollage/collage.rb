module Flickollage
  class Collage
    include Logger
    class Error < ::Flickollage::Error; end

    attr_reader :dictionary
    attr_reader :words
    attr_reader :options
    attr_reader :images

    RETRY_LIMIT = 10

    def initialize(words, options)
      @words = words
      @options = options

      init_dictionary
      load_images
      download_images
      crop_images(options[:width], options[:height])
    end

    def generate_collage(path = options[:output])
      MiniMagick::Tool::Montage.new do |montage|
        images.each { |image| montage << image.image.path }

        montage.geometry "#{options[:width]}x#{options[:height]}+0+0"
        montage.tile "#{options[:cols]}x#{options[:rows]}"

        montage << path
      end
    end

    private

    def init_dictionary
      @dictionary = Dictionary.new(options[:dict])
      @dictionary.append(words)
    rescue Flickollage::Dictionary::Error
      @dictionary = Dictionary.new(words)
    end

    def download_images
      images.each(&:download)
    end

    def crop_images(width, height)
      images.each do |image|
        image.crop(width, height)
      end
    end

    def load_images
      @images = []
      options[:number].times do
        @images << load_image
      end
    end

    def load_image(attempt = 1)
      word = dictionary.pop
      not_enought_words unless word
      Image.new(word)
    rescue Flickollage::Image::Error
      too_many_attempts if attempt == RETRY_LIMIT
      load_image(attempt + 1)
    end

    def not_enought_words
      raise Flickollage::Error,
            'Not enought words. Please, specify more words or provide a bigger dictionary.'
    end

    def too_many_attempts
      raise Flickollage::Error, 'Could not load images. Please, try later.'
    end
  end
end
