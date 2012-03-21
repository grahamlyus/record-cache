require 'spec_helper'

describe RecordCache::Strategy::FullTableCache do

  context "cacheable?" do
    before(:each) do
      # fill cache
      Orange.all  
    end

    it "should use the cache when a single id is requested" do
      lambda{ Orange.find(1) }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when a String id is requested" do
      lambda{ Orange.find('1') }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when a multiple ids are requested" do
      lambda{ Orange.find([1,2]) }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when a multiple String ids are requested" do
      lambda{ Orange.find(['1','2']) }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when a single id is requested and the limit is 1" do
      lambda{ Orange.where(:name => "Blue Orange 1").limit(1).all }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when a single id is requested and the limit is > 1" do
      lambda{ Orange.where(:name => "Blue Orange 1").limit(2).all }.should use_cache(Orange).on(:full_table).times(1)
    end

    it "should use the cache when multiple ids are requested and the limit is 1" do
      lambda{ Orange.where(:name => ["Blue Orange 1", "Blue Orange 2"]).limit(1).all }.should use_cache(Orange).on(:full_table).times(1)
    end
  end


  context "record_change" do
    before(:each) do
      # fill cache
      @orange1 = Orange.find(1)
    end

    it "should invalidate updated records" do
      @orange1.name = 'new name'
      @orange1.save!     
      lambda{ Orange.where(:id => 1).all }.should miss_cache(Orange).on(:full_table).times(1)
      lambda{ Orange.where(:id => 1).all }.should hit_cache(Orange).on(:full_table).times(1)    
    end

    it "should invalidate created records" do
      Orange.create!(:name => 'new name')
      lambda{ Orange.where(:id => 1).all }.should miss_cache(Orange).on(:full_table).times(1)
      lambda{ Orange.where(:id => 1).all }.should hit_cache(Orange).on(:full_table).times(1)    
    end

    it "should invalidate destroyed records" do
      @orange1.destroy
      lambda{ Orange.where(:id => 1).all }.should miss_cache(Orange).on(:full_table).times(1)
      lambda{ Orange.where(:id => 1).all }.should hit_cache(Orange).on(:full_table).times(1)
    end
  end

end
