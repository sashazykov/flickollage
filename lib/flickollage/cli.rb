# Flickollage Command Line Interface
class FlickollageCLI < Thor
  class << self
    COMMON_DICT_PATHS = %w(
      /usr/share/dict/words
      /usr/dict/words
    ).freeze

    def default_dict_path
      COMMON_DICT_PATHS.find { |path| File.exist?(path) } || COMMON_DICT_PATHS.first
    end
  end

  desc 'generate [WORDS]', 'Generate collage from the list of words'
  option :dict, type: :string, aliases: '-d', default: default_dict_path
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
    p words
    Flickollage.config = options
    FlickRaw.api_key = ENV['FLICKR_API_KEY'] || options[:flickr_api_key]
    FlickRaw.shared_secret = ENV['FLICKR_SHARED_SECRET'] || options[:flickr_shared_secret]
    return unless check_flickr_configuration
  end

  no_commands do
    def check_flickr_configuration
      return true if FlickRaw.api_key && FlickRaw.shared_secret
      puts 'Flickr configuration is not provided.'
      false
    end
  end
end
