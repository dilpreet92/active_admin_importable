require 'csv'
require 'open-uri'
class CsvDb
  class << self
    def convert_save(target_model, s3_url, &block)
      file = open(s3_url)
      csv_file = file.read
      CSV.parse(csv_file, :headers => true, header_converters: :symbol, col_sep: '&&&&&' ) do |row|
        data = row.to_hash
        if data.present?
          if (block_given?)
             block.call(target_model, data)
           else
             target_model.create!(data)
           end
         end
      end
    end
  end
end