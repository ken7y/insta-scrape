
# page = Nokogiri::HTML(open("https://www.instagram.com/p/BoVqWT8AqRh/liked_by/"))
#73 seconds for 600 likes
require 'webdrivers'
require 'watir'
require 'watir-scroll'
require 'net/http'
require 'webdriver-user-agent'

# puts res.body
timeStart = Time.now.to_i

driver = Webdriver::UserAgent.driver(browser: :chrome, agent: :iphone, orientation: :portrait)
browser = Watir::Browser.new driver

browser.goto("https://www.instagram.com/p/BsKLRHUnqle/")
# browser.driver.manage.window.maximize
20.times {browser.send_keys :down}

likes = 144

browser.link(text: "#{likes} likes").click

sleep(2)

likes = likes*2.5

likes.to_i.times {browser.send_keys :down}
5.times {browser.send_keys :up}

#d7Byh
timeEnd = Time.now.to_i

puts "Yeet"
puts timeEnd - timeStart

output = File.open( "outputfile.txt","w" )
output << browser.span(:id => 'react-root').inner_html.scan(/.{1,66} /).join("\n")
output.close


browser.element(css: ".js-generated-class").wait_until_present

# what i need to do is
#   scroll down in the followers list then grab the html inside.
#   issues : scroll down not working
#

# notes to self

# instagram you gotta scrape inbetween the li class=wo9IH tag
