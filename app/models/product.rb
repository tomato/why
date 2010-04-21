class Product < ActiveRecord::Base
  belongs_to :supplier
  validates_presence_of :name
  validates_numericality_of :price, :allow_blank => true
end
