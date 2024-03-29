# frozen_string_literal: true

require 'rspec'
palladium = PalladiumHelper.new(x2t.version, 'Conversion tests smoke')

describe 'Conversion tests' do
  after do |example|
    palladium.add_result(example)
  end

  StaticData::CONVERSION_STRAIGHT.each_pair do |format_from, formats_to|
    formats_to.each do |format|
      it "Check converting from #{format_from} to #{format}" do
        filepath = "#{StaticData::NEW_FILES_DIR}/new.#{format_from}"
        file_data = x2t.convert(filepath, format)
        expect(File).to exist(file_data[:tmp_filename])
      end
    end
  end

  it 'Check converting from docx to xlsx negative' do
    filepath = "#{StaticData::NEW_FILES_DIR}/new.docx"
    file_data = x2t.convert(filepath, :xlsx)
    expect(File).not_to exist(file_data[:tmp_filename])
  end

  it 'Check converting without CsvTxtEncoding parameter, negative' do
    filepath = "#{StaticData::BROKEN_FILES_DIR}/M6.7a.xps"
    file_data = x2t.convert(filepath, :docx, csv_txt_encoding: '')
    expect(File).not_to exist(file_data[:tmp_filename])
  end

  it 'Check conversion errors' do
    filepath = "#{StaticData::BROKEN_FILES_DIR}/It_is_docx_file.xlsx"
    file_data = x2t.convert(filepath, :xlst)
    expect(File).not_to exist(file_data[:tmp_filename])
    expect(file_data[:size_after]).to be_nil
    expect(file_data[:x2t_result]).to be_nil
  end
end
