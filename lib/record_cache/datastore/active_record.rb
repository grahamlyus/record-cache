require 'active_record'

# basic Record Cache functionality
ActiveRecord::Base.send(:include, RecordCache::Base)

# To be able to fetch records from the cache and invalidate records in the cache
# some internal Active Record methods needs to be aliased.
# The downside of using internal methods, is that they may change in different releases,
# hence the following code:
require File.dirname(__FILE__) + "/active_record_#{ActiveRecord::VERSION::MAJOR}#{ActiveRecord::VERSION::MINOR}.rb"
