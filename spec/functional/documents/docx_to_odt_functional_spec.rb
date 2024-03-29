# frozen_string_literal: true

require 'rspec'
palladium = PalladiumHelper.new(x2t.version, 'Docx to Odt')
result_sets = palladium.get_result_sets(StaticData::POSITIVE_STATUSES)
files = s3.files_from_folder('docx')
describe 'Conversion docx files to odt' do
  before do
    @tmp_dir = create_tmp_dir.first
  end

  (files - result_sets.map { |result_set| "docx/#{result_set}" }).each do |file|
    it File.basename(file) do
      s3.download_file_by_name(file, @tmp_dir)
      @file_data = x2t.convert("#{@tmp_dir}/#{File.basename(file)}", :odt)
      expect(File).to exist(@file_data[:tmp_filename])
    end
  end

  after do |example|
    spec_cleanup(@tmp_dir, @file_data[:tmp_filename])
    palladium.add_result(example, @file_data)
  end
end
