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

    context 'file not found' do
      let(:word) { 'kjasbdib823' }
      it 'should raise error' do
        VCR.use_cassette('flickr_not_found') do
          expect { subject }.to raise_error { Flickollage::Image::Error }
        end
      end
    end
  end

  describe '#as_file' do
    let(:image) { described_class.new(word) }
    let(:subject) { image.as_file }
    it 'should return a file' do
      VCR.use_cassette('flickr_download') do
        expect(subject).to be_a Tempfile
      end
    end

    context 'file not found' do
      before(:each) do
        # mock Flickr request
        allow_any_instance_of(Flickollage::Image).to receive(:search_on_flickr)
        expect(image).to receive(:url).and_return('https://farm1.staticflickr.com/758/not_found.jpg')
      end

      it 'should return nil' do
        VCR.use_cassette('flickr_download_not_found') do
          expect { subject }.to raise_error { Flickollage::Image::Error }
        end
      end
    end
  end
end
