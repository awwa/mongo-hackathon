require "mongo"

class DbAccess
  attr_accessor :db, :coll

  def initialize
    db = URI.parse("mongodb://localhost:27017/testtest")
    db_name = db.path.gsub(/^\//, '')

    @connection = Mongo::Connection.new(db.host, db.port)
    @db = @connection.db(db_name)
    @coll = @db.collection("coll")
  end

  def init
    self.drop_all

    self.create_data
  end

  def insert(doc)
    @coll.insert(doc)
  end

  def find_item(item_id)
    @coll.find({:item_id => item_id})
  end

  def find(filters = nil)
    if filters == nil then
      @coll.find
    else
      @coll.find(filters)
    end
  end

  def update(doc)
    @coll.update({:_id => doc.id}, doc.to_hash)
  end

  def remove(id)
    @coll.remove({:_id => id})
  end

  def drop_all
    @coll.drop
  end

  def create_data
    open("./sample.tsv") { |file|
      while l = file.gets
        values = l.split(nil)
        collection = {}
        collection["item_id"] = values[0]
        collection["item_name"] = values[1]
        collection["item_price"] = values[2].to_i
        self.insert(collection)
      end
    }

  end

end
