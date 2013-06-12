class Book < ActiveRecord::Base
  attr_accessible :author, :title

  acts_as_syncable
end
