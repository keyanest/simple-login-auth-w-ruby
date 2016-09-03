require_relative "session"
require 'csv'



#
new_start = Session.new
new_start.csv_scrape("testusers.csv")
new_start.run_auth
