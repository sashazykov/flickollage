module Flickollage
  class Image
    include Logger
    class Error < ::Flickollage::Error; end

    attr_reader :word
    attr_reader :url
    attr_accessor :image

    def initialize(word)
      @word = word
      search_on_flickr(word)
    end

    def download
      @image = MiniMagick::Image.open(url)
      file_not_found unless @image
      @image
    end

    def crop(width, height)
      dimensions = image.dimensions
      should_be_bigger = dimensions[0] < width || dimensions[1] < height
      image.combine_options do |b|
        b.resize "#{width}x#{height}^" if should_be_bigger
        b.gravity 'Center'
        b.crop "#{width}x#{height}!+0+0"
      end
    end

    private

    def file_not_found
      raise Error, "Failed to load an image for keyword '#{word}'."
    end

    def search_on_flickr(word)
      photo = flickr.photos.search(tags: word, sort: 'interestingness-desc', per_page: 1)[0]
      raise Error, 'Could not find an image using this keyword' unless photo
      @url = FlickRaw.url_b(photo)
    rescue FlickRaw::FailedResponse
      raise ::Flickollage::Error, 'Invalid Flickr API key'
    end
  end
end
