# frozen_string_literal: true

require 'rspec'
palladium = PalladiumHelper.new(x2t.version, 'Rtf to Docx')
result_sets = palladium.get_result_sets(StaticData::POSITIVE_STATUSES)
files = s3.get_files_by_prefix('rtf/')
describe 'Conversion rtf files to docx' do
  before do
    @tmp_dir = FileHelper.create_tmp_dir.first
  end

  (files - result_sets.map { |result_set| "rtf/#{result_set}" }).each do |file|
    it File.basename(file) do
      s3.download_file_by_name(file, @tmp_dir)
      @file_data = x2t.convert("#{@tmp_dir}/#{File.basename(file)}", :docx)
      expect(File).to exist(@file_data[:tmp_filename])
      expect(OoxmlParser::Parser.parse(@file_data[:tmp_filename])).to be_with_data unless StaticData::EMPTY_FILES.include?(File.basename(file))
    end
  end

  after do |example|
    FileHelper.delete_tmp(@tmp_dir)
    palladium.add_result(example, @file_data)
  end
end
