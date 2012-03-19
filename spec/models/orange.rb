class Orange < ActiveRecord::Base
  
  cache_records :store => :shared, :full_table => true

  belongs_to :store
  belongs_to :person
  
end
