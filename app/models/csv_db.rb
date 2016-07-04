require 'csv'
class CsvDb
  class << self
    def convert_save(target_model, csv_data, &block)
      file = File.open(File.join(Rails.root, 'public', 'csv_files', csv_data), 'r')
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
      File.delete(File.join(Rails.root, 'public', 'csv_files', csv_data))
    end
  end
end