require 'spec_helper'

describe Flickollage::Collage do
  let(:subject) { described_class.new(words, options) }
  let(:words) { %w(annapurna elbrus) }
  let(:options) do
    {
      dict: fixture_file_path('mountains'),
      number: 4,
      width: 100,
      height: 60,
      rows: 2,
      cols: 2
    }
  end

  let(:mocked_image) { MiniMagick::Image.open(fixture_file_path('rothko.jpg')) }

  before(:each) do
    # mock downloaded image
    allow_any_instance_of(Flickollage::Image).to receive(:search_on_flickr)
    allow_any_instance_of(Flickollage::Image).to receive(:download)
    allow_any_instance_of(Flickollage::Image).to receive(:image).and_return(mocked_image)
  end

  describe '#initialize' do
    it 'initializes a dictionary' do
      expect(subject.dictionary.words).not_to be_empty
    end

    it 'loads images' do
      expect(subject.images.size).to eq 4
    end

    it 'crops images' do
      allow_any_instance_of(Flickollage::Image).to receive(:crop)
      expect(subject.images).to all have_received(:crop).with(100, 60)
    end

    context 'when image can not be loaded' do
      before(:each) do
        expect(Flickollage::Image)
          .to receive(:new)
          .and_raise(Flickollage::Image::Error).exactly(described_class::RETRY_LIMIT).times
      end

      it 'should raise Flickollage::Error after RETRY_LIMIT attempts' do
        expect { subject }.to raise_error(Flickollage::Error)
      end
    end
  end

  describe '#generate_collage' do
    let(:output) { Tempfile.new(['collage', '.jpg']).path }
    let(:subject) { super().generate_collage(output) }
    let(:collage) { MiniMagick::Image.new(output) }

    before(:each) { subject }

    it 'should compose a collage and save it into a file' do
      expect(collage.dimensions).to eq [200, 120]
    end

    it 'should be similar to a sample image' do
      expect(output).to be_similar_to fixture_file_path('collage.jpg')
    end
  end
end
