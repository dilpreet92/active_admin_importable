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
        s3 = AWS::S3.new
        filename = params[:dump][:file].original_filename
        key = File.basename(filename)
        s3.buckets[Rails.application.secrets.bucket].acl = :public_read
        obj = s3.buckets[Rails.application.secrets.bucket].objects[key].write(:file => params[:dump][:file], acl:'public-read')
        CsvDb.delay.convert_save(active_admin_config.resource_class, obj.public_url.to_s, &block)
        redirect_to :action => :index, :notice => "#{active_admin_config.resource_name.to_s} imported successfully!"
      end
    end
  end
end
