# frozen_string_literal: true

require 'rspec'

palladium = PalladiumHelper.new(x2t.version, 'Assets tests smoke')

describe 'Assets tests' do
  after do |example|
    palladium.add_result(example)
  end

  describe 'libraries' do
    StaticData::LIBS_ARRAY.each do |lib|
      it "Lib #{lib} exist check" do
        expect(File).to exist("bin/#{lib}")
      end
    end
  end

  describe 'x2t' do
    it 'x2t exist check' do
      expect(File).to exist('bin/x2t')
    end

    it 'x2t version non empty check' do
      expect(x2t.version).not_to be_empty
    end
  end
end
