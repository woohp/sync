class Chapter < ActiveRecord::Base
  acts_as_syncable

  belongs_to :book
end
