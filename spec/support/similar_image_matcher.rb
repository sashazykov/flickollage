RSpec::Matchers.define :be_similar_to do |expected|
  match do |actual|
    expect do
      $stderr = StringIO.new
      MiniMagick::Tool::Compare.new do |compare|
        compare.merge! %W(-metric RMSE #{actual} #{expected} null:)
      end
      # expect($stderr.string).to eq '0 (0)'
      $stderr = STDERR
    end.not_to raise_error
  end
end
