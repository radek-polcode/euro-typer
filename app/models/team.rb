class Team < ActiveRecord::Base
  has_many :matches

  scope :ordered, -> { order :name }

  validates_presence_of :name, :abbreviation

  mount_uploader :photo, PhotoUploader
end
