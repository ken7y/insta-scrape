
# page = Nokogiri::HTML(open("https://www.instagram.com/p/BoVqWT8AqRh/liked_by/"))

require 'webdrivers'
require 'watir'
require 'watir-scroll'
require 'net/http'
require 'webdriver-user-agent'

# puts res.body

driver = Webdriver::UserAgent.driver(browser: :chrome, agent: :iphone, orientation: :portrait)
browser = Watir::Browser.new driver

browser.goto("https://www.instagram.com/p/BsXS8EThMib")
# browser.driver.manage.window.maximize
20.times {browser.send_keys :down}


browser.link(text: '994 likes').click

sleep(5)
2500.times {browser.send_keys :down}

# figure out query hash it makes then you make the request it makes
# puts browser.element.inner_html
puts "Yeet"

browser.element(css: ".js-generated-class").wait_until_present

# what i need to do is
#   scroll down in the followers list then grab the html inside.
#   issues : scroll down not working
#

# notes to self

# instagram you gotta scrape inbetween the li class=wo9IH tag
