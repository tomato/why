class Supplier < ActiveRecord::Base
  has_many :rounds
  has_many :products

  validates_presence_of :name
end
