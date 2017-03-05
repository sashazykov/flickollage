require 'spec_helper'

describe Flickollage::Collage do
  let(:subject) { described_class.new(words, options) }
  let(:words) { %w(annapurna elbrus) }
  let(:options) do
    {
      dict: fixture_file_path('mountains'),
      number: 4
    }
  end

  before(:each) do
    allow_any_instance_of(Flickollage::Image).to receive(:search_on_flickr)
  end

  describe '#initialize' do
    it 'initializes a dictionary' do
      expect(subject.dictionary.words).not_to be_empty
    end

    it 'loads images' do
      expect(subject.images.size).to eq 4
    end
  end
end
