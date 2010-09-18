class Supplier < ActiveRecord::Base
  has_many :rounds
  has_many :products

  validates_presence_of :name
  has_friendly_id :name, :use_slug => true
  has_attached_file :logo
end
