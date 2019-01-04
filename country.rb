# can check what countries are in the @@items array and also
# allow you to search if a country exists. will tell you if country
# exists or not

class Application
  # @@ variables are like static variables in java
  # @ variables are just instance variables in java
  # they are only available to the specific instance of a class

  @@items = ["Japan","Brazil","Canada"]
  def call(env)
    resp = Rack::Response.new
    resp.write "Hello Countries \n"
    req = Rack::Request.new(env)

    # @@items.each do |item|
    #   resp.write "#{item}\n"
    # end

    # if the path equals items
    # then do the below actions
    # if it we on localhost:9292/items then the list of
    # Countries will be displayed
    if req.path.match(/items/)
      @@items.each do |item|
        resp.write "#{item}\n"
      end
      # for below to work you need to go to a url like
      # http://localhost:9292/search?q=insertname
      # however if i change the q from req.params to w
      # the url would be
      # http://localhost:9292/search?w=Canada

    elsif req.path.match(/search/)
      search_term = req.params["q"]

      if @@items.include?(search_term)
        resp.write "#{search_term} is a legit country\n"
      else
        resp.write "Couldn't find #{search_term}\n"
      end

    else
      resp.write "Path not found"
    end


    resp.finish
  end

end
