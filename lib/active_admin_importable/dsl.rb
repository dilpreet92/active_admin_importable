module ActiveAdminImportable
  module DSL
    def active_admin_importable(&block)
      action_item :only => :index do
        link_to "Import #{active_admin_config.resource_name.to_s.pluralize}", :action => 'upload_csv'
      end

      collection_action :upload_csv do
        render "admin/csv/upload_csv"
      end

      collection_action :import_csv, :method => :post do
        file = params[:dump][:file].read
        filename = params[:dump][:file].original_filename
        File.open(File.join(Rails.root, 'public', 'csv_files', filename), 'wb') { |f| f.write file }
        CsvDb.delay.convert_save(active_admin_config.resource_class, filename, &block)
        redirect_to :action => :index, :notice => "#{active_admin_config.resource_name.to_s} imported successfully!"
      end
    end
  end
end