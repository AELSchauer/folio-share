class ZipGenerator
  attr_reader :download_type, :uploads, :file_name
  attr_accessor :temp_file

  def initialize(selection)
    @download_type = selection.class
    @file_name     = "#{selection.name}.zip"
    @uploads       = selection.all_uploads
    @temp_file     = Tempfile.new(file_name)
  end

  def download
    if uploads.empty?
      :failure
    else
      Zip::File.open(temp_file.path, Zip::File::CREATE) do |zipfile|
        uploads.each do |upload|
          if download_type == Folder
            upload_path = upload.folio_filepath
          elsif download_type == Upload
            upload_path = upload.name
          end
          zipfile.add(upload_path, upload.local_filepath)
        end
      end
      :success
    end
  end

  def data
    File.read(temp_file.path)
  end

  def close
    temp_file.close
    temp_file.unlink
  end
end
