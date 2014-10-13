# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "ItemData" do

  describe "validate methods" do
    it "put_star" do
      item = ItemData.new
      expect(item.stars.length).to eq(0)

      item.put_star(3)
      expect(item.stars.length).to eq(1)
      expect(item.stars[0]).to eq(3)
      item_array = item.to_hash
      expect(item_array["star_ave"]).to eq(3)
      expect(item_array["star_max"]).to eq(3)
      expect(item_array["star_min"]).to eq(3)

      item.put_star(5)
      expect(item.stars.length).to eq(2)
      expect(item.stars[0]).to eq(3)
      expect(item.stars[1]).to eq(5)
      item_array = item.to_hash
      expect(item_array["star_ave"]).to eq(4)
      expect(item_array["star_max"]).to eq(5)
      expect(item_array["star_min"]).to eq(3)

      item.put_star(1)
      expect(item.stars.length).to eq(3)
      expect(item.stars[0]).to eq(3)
      expect(item.stars[1]).to eq(5)
      expect(item.stars[2]).to eq(1)
      item_array = item.to_hash
      expect(item_array["star_ave"]).to eq(3)
      expect(item_array["star_max"]).to eq(5)
      expect(item_array["star_min"]).to eq(1)

      item.put_star(1)
      expect(item.stars.length).to eq(4)
      expect(item.stars[0]).to eq(3)
      expect(item.stars[1]).to eq(5)
      expect(item.stars[2]).to eq(1)
      expect(item.stars[3]).to eq(1)
      item_array = item.to_hash
      expect(item_array["star_ave"]).to eq(2)
      expect(item_array["star_max"]).to eq(5)
      expect(item_array["star_min"]).to eq(1)
    end

    it "put_star" do
      item = ItemData.new
      expect(item.stars.length).to eq(0)
      item.put_tag("tag1")
      item.put_tag("tag2")
      item.put_tag("タグ3")
      expect(item.tags.length).to eq(3)
      expect(item.tags[0]).to eq("tag1")
      expect(item.tags[1]).to eq("tag2")
      expect(item.tags[2]).to eq("タグ3")
    end


  end

end
