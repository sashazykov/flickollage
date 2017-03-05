require 'spec_helper'

describe Flickollage::Image do
  let(:word) { 'dolomites' }
  let(:subject) { described_class.new(word) }

  let(:flickr_api_key) { ENV['FLICKR_API_KEY'] || 'key' }
  let(:flickr_shared_key) { ENV['FLICKR_SHARED_SECRET'] || 'secret' }

  before(:each) do
    Flickollage.configure_flickraw(
      flickr_api_key: flickr_api_key,
      flickr_shared_secret: flickr_shared_key
    )
  end

  describe '#initialize' do
    it 'should retrieve image url from flickr' do
      VCR.use_cassette('flickr') do
        expect(subject.url).to match(/staticflickr\.com/)
      end
    end
  end

  describe '#as_file' do
    let(:subject) { super().as_file }
    it 'should return a file' do
      VCR.use_cassette('flickr_download') do
        expect(subject).to be_a Tempfile
      end
    end
  end
end
