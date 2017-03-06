require 'thor'
require 'dotenv'
require 'logger'

# Flickollage Command Line Interface
module Flickollage
  class CLI < ::Thor
    include Logger

    desc 'generate [LIST OF WORDS]', 'Generate collage from the list of words'
    option :dict,
           type: :string, aliases: '-d', default: Dictionary.default_dict_path,
           desc: 'Path of the dictionatry file'
    option :output,
           type: :string, aliases: '-o', default: 'collage.png',
           desc: 'Output image file name'
    option :flickr_api_key,
           type: :string,
           desc: 'Flickr API Key, can also be set using environment variable'
    option :flickr_shared_secret,
           type: :string,
           desc: 'Flickr Shared Secret, can also be set using environment variable'
    option :number, type: :numeric, aliases: '-n', default: 10
    option :rows, type: :numeric, aliases: '-r', default: 5
    option :cols, type: :numeric, aliases: '-c', default: 2
    option :width, type: :numeric, aliases: '-w', default: 200
    option :height, type: :numeric, aliases: '-h', default: 150
    option :verbose, type: :boolean, aliases: '-v'
    long_desc <<-LONGDESC
      `flickollage generate dolomites annapurna` will generate a photo collage.

      You can provide flickr api key and shared secret using options described before
      or environment variables `FLICKR_API_KEY` and `FLICKR_SHARED_SECRET`.
    LONGDESC
    def generate(*words)
      Flickollage.init_logger(options)
      Flickollage.configure_flickraw(options)
      Flickollage::Collage.new(words, options).generate_collage
    rescue Flickollage::Error => e
      logger.error(e.message)
      logger.debug(e.inspect)
    end
  end
end
