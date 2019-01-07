
# page = Nokogiri::HTML(open("https://www.instagram.com/p/BoVqWT8AqRh/liked_by/"))

require 'webdrivers'
require 'watir'
require 'net/http'
require 'webdriver-user-agent'

# puts res.body

driver = Webdriver::UserAgent.driver(browser: :chrome, agent: :iphone, orientation: :portrait)
browser = Watir::Browser.new driver

browser.goto("https://www.instagram.com/p/BoVqWT8AqRh")
# browser.driver.manage.window.maximize
browser.execute_script("window.scrollTo(0, document.body.scrollHeight);\n")

browser.link(text: '148 likes').click

scrollable = browser.div(class: 'j6cq2') # div with overflow-y=scroll


# figure out query hash it makes then you make the request it makes
puts browser.element.inner_html
puts "Yeet"

browser.element(css: ".js-generated-class").wait_until_present

# what i need to do is
#   scroll down in the followers list then grab the html inside.
#   issues : scroll down not working
#

# notes to self

# instagram you gotta scrape inbetween the li class=wo9IH tag
