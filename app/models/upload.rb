class Upload < ApplicationRecord
  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder
  delegate :user, to: :folder
  has_many :comments

  # validates :attachment, presence: true, file_size: { maximum: 2.gigabytes }

#   validates :attachment, presence: true

  validates :name, presence: true
  validates :content_type, presence: true
  validates :size, presence: true
  validates :folder_id, presence: true

  def all_uploads
    [self]
  end

  def ancestors
    folder.ancestors << folder
  end

  def directory
    ancestors.map(&:name).join("/")
  end

  def folio_filepath
    "#{directory}/#{name}"
  end

  def local_filepath
    attachment.file.file
  end

  def owner
    self.folder.owner.id
  end

  def display_privacy
    is_private ? "Private" : "Public"
  end

  def opposite_privacy
    is_private ? "Public" : "Private"
  end

  def change_privacy
    assign_attributes(is_private: !is_private)
  end

end
