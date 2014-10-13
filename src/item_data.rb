class ItemData

  attr_accessor :id, :item_id, :item_name, :item_price, :stars, :star_ave, :star_max, :star_min, :tags, :like, :comment

  def initialize
    @stars = []
    @tags = []
    @like = 0
    @comment = []
  end

  def put_star(star)
    @stars.push(star)
    @star_max = @stars.max if @stars.length > 0
    @star_min = @stars.min if @stars.length > 0
    @star_ave = @stars.inject {|sum, n| sum + n} / @stars.length if @stars.length > 0
  end

  def put_tag(tag_string)
    @tags.push(tag_string)
  end

  def put_like
    @like = @like + 1
  end

  def put_comment(comment)
    @comment.unshift(comment)
  end

  def to_hash
    data = {}
    data["_id"] = @id
    data["item_id"] = @item_id
    data["item_name"] = @item_name
    data["item_price"] = @item_price
    data["stars"] = @stars
    data["star_max"] = @star_max
    data["star_min"] = @star_min
    data["star_ave"] = @star_ave
    data["tags"] = @tags
    data["like"] = @like
    data["comment"] = @comment
    data
  end

  def self.create_new(data)
    obj = ItemData.new
    obj.id = data["_id"]
    obj.item_id = data["item_id"]
    obj.item_name = data["item_name"]
    obj.item_price = data["item_price"]
    obj.stars = data["stars"]
    obj.stars = [] if obj.stars == nil
    obj.star_max = data["star_max"]
    obj.star_min = data["star_min"]
    obj.star_ave = data["star_ave"]
    obj.tags = data["tags"]
    obj.tags = [] if obj.tags == nil
    obj.like = data["like"]
    obj.like = 0 if obj.like == nil
    obj.comment = data["comment"]
    obj.comment = [] if obj.comment == nil
    obj
  end

end
