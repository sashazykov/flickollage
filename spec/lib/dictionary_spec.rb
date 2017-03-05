require 'spec_helper'

describe Flickollage::Dictionary do
  let(:path) { fixture_file_path('mountains') }
  let(:subject) { described_class.new(path) }

  describe '#initialize' do
    it 'should load all words' do
      expect(subject.words.size).to be > 20
    end

    it 'shuffles the dictionary' do
      dictionary2 = described_class.new(path)
      expect(subject.words).not_to eq dictionary2.words
    end

    context 'huge file' do
      before(:each) { stub_const('Flickollage::Dictionary::MAX_DICT_LENGTH', 5) }
      it 'limits dictionary size' do
        expect(subject.words.size).to eq 5
      end
    end

    context 'file not found' do
      let(:path) { '/not/a/file' }

      it 'raise an error' do
        expect { subject }.to raise_error Flickollage::Dictionary::Error
      end
    end
  end

  describe '#words' do
    let(:subject) { super().words }

    it 'returns the list of loaded words' do
      expect(subject).to be_an Array
    end

    it 'does not contain empty words' do
      expect(subject).not_to include ''
    end
  end

  describe '#word' do
    let!(:dictionary) { described_class.new(path) }
    let(:subject) { dictionary.word }
    it 'should return a random word' do
      expect(subject).not_to be_empty
    end

    it 'should not be a multi-line string' do
      expect(subject).not_to include "\n"
    end

    it 'should remove a word from the dictionary' do
      expect { subject }.to change { dictionary.words.size }.by(-1)
    end
  end

  describe '#default_dict_path' do
    let(:subject) { described_class.default_dict_path }
    it 'should return one of the common dict paths' do
      expect(described_class::COMMON_DICT_PATHS).to include subject
    end
  end
end
