# when accessing a site e.g http://localhost:9292/items/KFC
# the price of kfc will be displayed. However if the suffix doesn't exist
# e.g http://localhost:9292/items/tacos an error message will be displayed
# with status code 400 returned. However if the link doesn't contain /items/
# then a 404 will be returned


class Item

  attr_accessor :name, :price

  def initialize(name,price)
    @name = name
    @price = price
  end
end


class Application
  @@items = [Item.new("Cake", "$5"),
    Item.new("Diamond","$6000"),
    Item.new("KFC","$12")]

    def call(env)
      resp = Rack::Response.new
      req = Rack::Request.new(env)

      if req.path.match(/items/)
        item_name = req.path.split("/items/").last
        resp.write item_name + "\n"

        if @@items.any?{|a| a.name == item_name}
          item = @@items.find{|s| s.name == item_name}
          resp.write item.price
        else
          resp.write "Could not find #{item_name} \n"
          resp.status = 400
        end
      else
        resp.status = 404
      end
      resp.finish

    end
  end
