# encoding: utf-8
require File.dirname(__FILE__) + '/spec_helper'


describe "Main" do
  include Rack::Test::Methods
  def app
    @app ||= Mongo::Main
  end

  before {
    dba = DbAccess.new
    dba.init
  }

  describe "get /" do
    before { get "/" }
    subject { last_response }
    it "Validate response" do
      expect(subject.body).to eq("Hello")
    end
  end

  describe "listItems all" do
    before { get "/api/listItems" }
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.to_a.length).to eq(900)
    end
  end

  describe "listItems by item_price" do
    before { get "/api/listItems?item_price_from=500&item_price_to=700"}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.to_a.length).to eq(203)
    end
  end

  describe "showItem by item_id" do
    before { get "/api/showItem/md00001"}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
    end
  end

  describe "evalItem" do
    before {put "/api/evalItem/md00001?star=3"}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("star_ave")).to eq(true)
      expect(json["star_ave"]).to eq(3)
      expect(json.has_key?("star_max")).to eq(true)
      expect(json["star_max"]).to eq(3)
      expect(json.has_key?("star_min")).to eq(true)
      expect(json["star_min"]).to eq(3)
    end
  end

  describe "listItems by star" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_star(5)
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_star(3)
      item.put_star(1)
      dba.update(item)

      get "/api/listItems?star_ave_from=2"
      }
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.to_a.length).to eq(2)
    end
  end

  describe "addTag" do
    before {put URI.encode("/api/addTag/md00001/めちゃうまい")}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("star_ave")).to eq(true)
      expect(json["tags"].length).to eq(1)
      expect(json["tags"][0]).to eq("めちゃうまい")
    end
  end

  describe "listItems by tag" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_tag("めちゃうまい")
      dba.update(item)

      get URI.encode("/api/listItems?tag=めちゃうまい")
    }
    subject { last_response }
    it "Validate response" do
      #puts subject.body
      json = JSON.parse(subject.body)
      expect(json.to_a.length).to eq(1)
    end
  end

  describe "showItem with tag" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_tag("めちゃうまい")
      dba.update(item)

      get URI.encode("/api/showItem/md00001")
    }
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("star_ave")).to eq(true)
      expect(json["tags"].length).to eq(1)
      expect(json["tags"][0]).to eq("めちゃうまい")
    end
  end

  describe "addLike" do
    before {put URI.encode("/api/addLike/md00001")}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("like")).to eq(true)
      expect(json["like"]).to eq(1)
    end
  end

  describe "listItems by like" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_like
      item.put_like
      item.put_like
      item.put_like
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00002").to_a[0])
      item.put_like
      dba.update(item)

      item = ItemData.create_new(dba.find_item("md00003").to_a[0])
      item.put_like
      item.put_like
      item.put_like
      dba.update(item)

      get URI.encode("/api/listItems?like_from=3")
    }
    subject { last_response }
    it "Validate response" do
      #puts subject.body
      json = JSON.parse(subject.body)
      expect(json.to_a.length).to eq(2)
    end
  end

  describe "showItem with like" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_like
      item.put_like
      item.put_like
      item.put_like
      dba.update(item)

      get URI.encode("/api/showItem/md00001")
    }
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("star_ave")).to eq(true)
      expect(json.has_key?("like")).to eq(true)
      expect(json["like"]).to eq(4)
    end
  end

  describe "addComment" do
    before {put URI.encode("/api/addComment/md00001?comment=これは面白い")}
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("comment")).to eq(true)
      expect(json["comment"][0]).to eq("これは面白い")
    end
  end

  describe "showItem with comment" do
    before {
      dba = DbAccess.new
      item = ItemData.create_new(dba.find_item("md00001").to_a[0])
      item.put_comment("これは面白い")
      dba.update(item)

      get URI.encode("/api/showItem/md00001")
    }
    subject { last_response }
    it "Validate response" do
      json = JSON.parse(subject.body)
      expect(json.has_key?("item_id")).to eq(true)
      expect(json.has_key?("item_name")).to eq(true)
      expect(json.has_key?("item_price")).to eq(true)
      expect(json.has_key?("star_ave")).to eq(true)
      expect(json.has_key?("comment")).to eq(true)
      expect(json["comment"]).to eq(["これは面白い"])
    end
  end


end
