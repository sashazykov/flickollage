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

  describe '#download' do
    let(:image) { described_class.new(word) }
    let(:subject) { image.download }
    it 'should return an mini magick object' do
      VCR.use_cassette('flickr_download') do
        expect(subject).to be_a MiniMagick::Image
      end
    end

    context 'file not found' do
      before(:each) do
        # mock Flickr request
        allow_any_instance_of(Flickollage::Image).to receive(:search_on_flickr)
        expect(image).to receive(:url).and_return('https://farm1.staticflickr.com/758/not_found.jpg')
      end

      it 'should raise en error' do
        VCR.use_cassette('flickr_download_not_found') do
          expect { subject }.to raise_error { Flickollage::Image::Error }
        end
      end
    end
  end

  describe '#crop' do
    let(:image) { described_class.new(word).tap(&:download) }
    let(:crop_size) { [150, 100] }
    let(:subject) { image.crop(*crop_size) }
    before(:each) do
      VCR.use_cassette('flickr_download') do
        image
      end
    end
    it 'crops the image' do
      expect { subject }.to change { image.image.dimensions }.to crop_size
    end

    context 'result is bigger that the source' do
      let(:crop_size) { [1500, 1500] }
      it 'makes the image bigger' do
        expect { subject }.to change { image.image.dimensions }.to crop_size
      end
    end
  end
end
