class Book < ActiveRecord::Base
  attr_accessible :author, :title

  has_many :chapters
  has_many :reviews

  acts_as_syncable dependent: :chapters
end
