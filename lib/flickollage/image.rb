module Flickollage
  class Image
    class Error < ::Flickollage::Error; end

    attr_reader :word
    attr_reader :url

    def initialize(word)
      @word = word
      search_on_flickr(word)
    end

    def as_file
      response = Faraday.get(url)
      return unless response.success?
      Tempfile.new(word).tap do |f|
        f.binmode
        f.write(response.body)
        f.fsync
        f.rewind
      end
    end

    private

    def search_on_flickr(word)
      photo = flickr.photos.search(tags: word, sort: 'interestingness-desc', per_page: 1)[0]
      raise Error, 'Could not find an image using this keyword' unless photo
      @url = FlickRaw.url_b(photo)
    rescue FlickRaw::FailedResponse
      raise ::Flickollage::Error, 'Invalid Flickr API key'
    end
  end
end
