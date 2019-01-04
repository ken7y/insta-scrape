
# page = Nokogiri::HTML(open("https://www.instagram.com/p/BoVqWT8AqRh/liked_by/"))

require 'webdrivers'
require 'watir'
browser = Watir::Browser.new
browser.goto("https://www.instagram.com/p/BoVqWT8AqRh")
browser.driver.manage.window.maximize
# browser.element(css: ".js-generated-class").wait_until_present
# js_rendered_content = browser.element(css: ".js-generated-class")
# browser.link(:class => 'Ls00D coreSpriteDismissLarge Jx1OT').click
browser.link(text: '148 likes').click
browser.element(css: ".js-generated-class").wait_until_present

puts browser.body

# notes to self

# instagram you gotta scrape inbetween the li class=wo9IH tag
