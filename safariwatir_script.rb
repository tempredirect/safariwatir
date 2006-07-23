require 'rubygems'
require 'safariwatir'

# TODO 
# Need to give feedback when browser dies
# Be more attached to the Safari window, if a different window is selected, the AppleScript executes against it
# Verify onclick is working for buttons and links
# TextFields should not respond to button method, etc.

# Unsupported Elements: UL/OL
# Use dynamic properties for Javascript optimization?
# Will I need to push more functionality into AppleScript to speed things up?
# Angrez is looking into the Ruby/AppleScript binding
# Watir Rails Plugin needed -> Watir test generator, fixtures and AR in-test, Browser Factory

# SAFARI ISSUES
# Labels are not clickable
# No known way to programatically click a <button> 
# Links with href="javascript:foo()"

safari = Watir::Safari.new

def safari.google_to_prag
  goto("http://google.com")
  text_field(:name, "q").set("pickaxe")
  button(:name, "btnG").click
  link(:text, "The Pragmatic Programmers, LLC: Programming Ruby").click
  link(:url, "http://www.pragmaticprogrammer.com/titles/ruby/code/index.html").click
  link(:text, "Catalog").click
  link(:text, "All Books").click
  link(:text, /Agile Retrospectives/).click
  puts "FAILURE prag" unless contains_text("Dave Hoover")  
end

def safari.ala
  goto("http://alistapart.com/")
  text_field(:id, "search").set("grail")
  checkbox(:id, "incdisc").set
  button(:id, "submit").click
  puts "FAILURE ala" unless contains_text('Search Results for “grail”')
end

def safari.amazon
  goto("http://amazon.com")
  select_list(:name, "url").select("Toys")
  select_list(:name, "url").select_value("index=software")
  text_field(:name, "keywords").set("Orion")
  image(:name, "Go").click
  puts "FAILURE amazon" unless contains_text("Master of Orion (Original Release) (PC)")
end

def safari.google_advanced
  goto("http://www.google.com/advanced_search")
  radio(:name, "safe", "active").set
  radio(:name, "safe", "images").set
  # Safari doesn't support label clicking ... perhaps I should raise an Exception
  label(:text, "No filtering").click
  radio(:id, "ss").set
  text_field(:name, "as_q").set("obtiva")
  button(:name, "btnG").click
  puts "FAILURE google" unless contains_text("RailsConf Facebook")
end

def safari.reddit
  goto("http://reddit.com/")
  text_field(:name, "user").set("foo")
  password(:name, "passwd").set("bar")
  form(:index, 1).submit
  puts "FAILURE reddit" unless contains_text("foo") and contains_text("logout")  
end

def safari.colbert
  goto("http://www.colbertnation.com/cn/contact.php")
  text_field(:name, "formmessage").set("Beware the Bear")
  button(:value, "Send Email").click
  puts "FAILURE colbert" unless text_field(:name, "formmessage").verify_contains("Enter message")  
end

def safari.redsquirrel
  goto("http://redsquirrel.com/")
  begin
    text_field(:id, "not_there").set("imaginary")
    puts "FAILURE squirrel text no e"
  rescue Watir::UnknownObjectException => e
    puts "FAILURE squirrel text bad e" unless e.message =~ /not_there/
  end
  begin
    link(:text, "no_where").click
    puts "FAILURE squirrel link no e"
  rescue Watir::UnknownObjectException => e
    puts "FAILURE squirrel link bad e" unless e.message =~ /no_where/
  end
end

safari.google_to_prag
safari.ala
safari.amazon
safari.google_advanced
safari.reddit
safari.colbert
safari.redsquirrel

safari.close