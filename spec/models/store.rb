class Store < ActiveRecord::Base

  cache_records :store => :local, :key => "st"

  belongs_to :owner, :class_name => "Person"

  has_many :apples, :autosave => true  # cached with index on store
  has_many :bananas # cached without index on store
  has_many :pears   # not cached
  has_many :oranges # full table cache
  has_one :address, :autosave => true

  has_and_belongs_to_many :customers, :class_name => "Person"

end
