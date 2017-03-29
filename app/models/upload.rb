class Upload < ApplicationRecord
  has_attached_file :file
  validates_attachment_content_type :file, content_type: all

  belongs_to :folder

  alias_attribute :name, :file_file_name
  alias_attribute :content_type, :file_content_type
  alias_attribute :size, :file_file_size

  def user
    folder.user
  end
end
p