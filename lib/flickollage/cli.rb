require 'thor'
require 'dotenv'
require 'logger'

# Flickollage Command Line Interface
module Flickollage
  class CLI < ::Thor
    include Logger

    desc 'generate [LIST OF WORDS]', 'Generate collage from the list of words'
    option :dict, type: :string, aliases: '-d', default: Dictionary.default_dict_path
    option :output, type: :string, aliases: '-o', default: 'collage.jpg'
    option :flickr_api_key, type: :string
    option :flickr_shared_secret, type: :string
    option :verbose, type: :boolean, aliases: '-v'
    long_desc <<-LONGDESC
      `flickollage generate dolomites annapurna` will generate a photo collage.

      You can provide flickr api key and shared secret using options described before
      or environment variables `FLICKR_API_KEY` and `FLICKR_SHARED_SECRET`.
    LONGDESC
    def generate(*words)
      Flickollage.init_logger(options)
      Flickollage.init_config(options)
      return unless Flickollage.configure_flickraw(options)
      words.each do |word|
        logger.info 'Found an image: ' + Image.new(word).url
      end
    rescue Flickollage::Error => e
      logger.error(e.message)
      logger.debug(e.inspect)
    end
  end
end
