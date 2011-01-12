class Supplier < ActiveRecord::Base
  has_many :rounds
  has_many :products

  validates_presence_of :name
  validates_format_of :parent_url, :with => URI::regexp(%w(http https)), :if => :embed
  has_friendly_id :name, :use_slug => true
  has_attached_file :logo
end
