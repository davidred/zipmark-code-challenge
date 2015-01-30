class Bank < ActiveRecord::Base

  validates :routing_number, uniqueness: true, presence: true
  validates :name, presence: true

end
