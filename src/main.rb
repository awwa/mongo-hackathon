require "sinatra/base"
require "sinatra/reloader"
require "json"
require "./src/db_access"
require "./src/item_data"

module Mongo
  class Main < Sinatra::Base

    enable :method_override

    configure do
      dba = DbAccess.new
      dba.init
    end

    helpers do
      def query_to_hash(query_string)
        params = {}
        ps = query_string.split('&')
        ps.each{|bbb|
          ccc = bbb.split('=')
          params.store("#{ccc[0]}", URI.decode(ccc[1]))
        }
        params
      end
    end

    get '/' do
      "Hello"
    end

    get '/api/listItems' do
      query = request.query_string
      dba = DbAccess.new
      if query.length == 0 then
        res = dba.find
      else
        q = query_to_hash(query)
        filters = {}

        price_filter = {}
        price_filter["$gt"] = q["item_price_from"].to_i if q.has_key?("item_price_from")
        price_filter["$lt"] = q["item_price_to"].to_i if q.has_key?("item_price_to")
        filters[:item_price] = price_filter if price_filter.has_key?("$gt") && price_filter.has_key?("$lt")

        star_ave_filter = {}
        star_ave_filter["$gte"] = q["star_ave_from"].to_i if q.has_key?("star_ave_from")
        star_ave_filter["$lte"] = q["star_ave_to"].to_i if q.has_key?("star_ave_to")
        filters[:star_ave] = star_ave_filter if star_ave_filter.has_key?("$gte") || star_ave_filter.has_key?("$lte")

        star_max_filter = {}
        star_max_filter["$gte"] = q["star_max_from"].to_i if q.has_key?("star_max_from")
        star_max_filter["$lte"] = q["star_max_to"].to_i if q.has_key?("star_max_to")
        filters[:star_max] = star_max_filter if star_max_filter.has_key?("$gte") || star_max_filter.has_key?("$lte")

        star_min_filter = {}
        star_min_filter["$gte"] = q["star_min_from"].to_i if q.has_key?("star_min_from")
        star_min_filter["$lte"] = q["star_min_to"].to_i if q.has_key?("star_min_to")
        filters[:star_min] = star_min_filter if star_min_filter.has_key?("$gte") || star_min_filter.has_key?("$lte")

        filters[:tags] = URI.decode(q["tag"]) if q.has_key?("tag")

        like_filter = {}
        like_filter["$gte"] = q["like_from"].to_i if q.has_key?("like_from")
        like_filter["$lte"] = q["like_to"].to_i if q.has_key?("like_to")
        filters[:like] = like_filter if like_filter.has_key?("$gte") || like_filter.has_key?("$lte")

        res = dba.find(filters)
      end
      coll = res.to_a
      JSON.generate(coll)
    end

    get '/api/showItem/:item_id' do
      dba = DbAccess.new
      res = dba.find_item(params[:item_id])
      coll = res.to_a
      if coll.length > 0 then
        JSON.generate(ItemData.create_new(coll[0]).to_hash)
      else
        JSON.generate([])
      end
    end

    put '/api/evalItem/:item_id' do
      query = request.query_string
      q = query_to_hash(query)
      star = q["star"].to_i

      dba = DbAccess.new
      res = dba.find_item(params[:item_id])
      coll = res.to_a
      if coll.length > 0 then
        item = ItemData.create_new(coll[0])
        item.put_star(star)
        dba.update(item)
        JSON.generate(item.to_hash)
      else
        "No results"
      end
    end

    put "/api/addTag/:item_id/:tag_string" do
      dba = DbAccess.new
      res = dba.find_item(params[:item_id])
      coll = res.to_a
      if coll.length > 0 then
        item = ItemData.create_new(coll[0])
        item.put_tag(params[:tag_string])
        dba.update(item)
        JSON.generate(item.to_hash)
      else
        "No results"
      end
    end

    put "/api/addLike/:item_id" do
      dba = DbAccess.new
      res = dba.find_item(params[:item_id])
      coll = res.to_a
      if coll.length > 0 then
        item = ItemData.create_new(coll[0])
        item.put_like
        dba.update(item)
        JSON.generate(item.to_hash)
      else
        "No results"
      end
    end

    put "/api/addComment/:item_id" do
      query = request.query_string
      q = query_to_hash(query)
      comment = q["comment"]

      dba = DbAccess.new
      res = dba.find_item(params[:item_id])
      coll = res.to_a
      if coll.length > 0 then
        item = ItemData.create_new(coll[0])
        item.put_comment(comment)
        dba.update(item)
        JSON.generate(item.to_hash)
      else
        "No results"
      end

    end

  end
end
