# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "DbAccess" do

  describe "validate methods" do
    it "find" do
      dba = DbAccess.new
      dba.init
      coll = dba.find.to_a
      expect(coll.length).to eq(900)
      coll.each {|row|
        item = ItemData.create_new(row)
        expect(item.instance_of? ItemData).to be == true
      }
    end

    it "find_item" do
      dba = DbAccess.new
      dba.init
      coll = dba.find_item("md00001").to_a
      expect(coll.length).to eq(1)
      coll.each {|row|
        item = ItemData.create_new(row)
        #puts item.inspect
      }
    end

    it "find_by_price" do
      dba = DbAccess.new
      dba.init

      price_filter = {}
      price_filter["$gt"] = 500
      price_filter["$lt"] = 700
      filters = {}
      filters[:item_price] = price_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(203)
      coll.each {|row|
        item = ItemData.create_new(row)
        #puts item.inspect
      }
    end

    it "find_by_star_ave_3" do
      dba = DbAccess.new
      dba.init

      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(3)
      dba.update(item)

      star_ave_filter = {}
      star_ave_filter["$gte"] = 2
      star_ave_filter["$lte"] = 3
      filters = {}
      filters[:star_ave] = star_ave_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(1)
      coll.each {|row|
        item = ItemData.create_new(row)
      }
    end

    it "find_by_star_max_5" do
      dba = DbAccess.new
      dba.init

      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(5)
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      star_max_filter = {}
      star_max_filter["$gte"] = 3
      star_max_filter["$lte"] = 5
      filters = {}
      filters[:star_max] = star_max_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(2)
      coll.each {|row|
        item = ItemData.create_new(row)
      }
    end

    it "find_by_star_min_2" do
      dba = DbAccess.new
      dba.init

      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(2)
      item.put_star(1)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_star(1)
      dba.update(item)

      star_min_filter = {}
      star_min_filter["$gte"] = 1
      star_min_filter["$lte"] = 3
      filters = {}
      filters[:star_min] = star_min_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(2)
      coll.each {|row|
        item = ItemData.create_new(row)
      }
    end

    it "find_by_star" do
      dba = DbAccess.new
      dba.init

      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(1)
      item.put_star(2)
      item.put_star(3)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_star(5)
      item.put_star(4)
      item.put_star(3)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00003").to_a[0])
      item.put_star(1)
      item.put_star(3)
      item.put_star(5)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00004").to_a[0])
      item.put_star(4)
      item.put_star(2)
      dba.update(item)

      star_ave_filter = {}
      star_ave_filter["$gte"] = 3
      star_ave_filter["$lte"] = 3
      star_max_filter = {}
      star_max_filter["$gte"] = 5
      filters = {}
      filters[:star_ave] = star_ave_filter
      filters[:star_max] = star_max_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(1)
      coll.each {|row|
        item = ItemData.create_new(row)
        #puts item.inspect
      }
    end

    it "find_by_star_0" do
      dba = DbAccess.new
      dba.init

      star_ave_filter = {}
      star_ave_filter["$gte"] = 2
      filters = {}
      filters[:star_ave] = star_ave_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(0)
      coll.each {|row|
        item = ItemData.create_new(row)
        #puts item.inspect
      }
    end

    it "find_by_star_2" do
      dba = DbAccess.new
      dba.init

      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(5)
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      star_ave_filter = {}
      star_ave_filter["$gte"] = 2
      filters = {}
      filters[:star_ave] = star_ave_filter
      coll = dba.find(filters).to_a
      expect(coll.length).to eq(2)
      coll.each {|row|
        item = ItemData.create_new(row)
        #puts item.inspect
      }
    end



    it "update" do
      dba = DbAccess.new
      dba.init
      coll = dba.find_item("md00001").to_a
      expect(coll.length).to eq(1)
      row = coll[0]
      item = ItemData.create_new(row)
      item.put_star(3)
      item.put_star(5)
      item.put_star(1)
      dba.update(item)
      coll = dba.find_item("md00001").to_a
      row = coll[0]
      item = ItemData.create_new(row)
      expect(item.stars.length).to eq(3)
    end


  end

end
