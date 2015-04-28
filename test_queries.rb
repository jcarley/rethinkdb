#!/usr/bin/env ruby

require 'rethinkdb'
require 'json'

include RethinkDB::Shortcuts

database_name = "esp_submission_development"
table_name = "contributions"

conn = r.connect(:host => "localhost", :port => 28015)

# Create a secondary index on the last_name attribute
# r.db(database_name).table(table_name).index_create("media_type").run(conn)

# Wait for the index to be ready to use
# r.db(database_name).table(table_name).index_wait("media_type").run(conn)

group_op = Proc.new { |contribution| contribution['media_type'] }
count = r.db(database_name).table(table_name).group(:index => 'media_type').count.run(conn)

puts "Count: #{count}"



# if asset_family == "Getty::GettyEditorial"
  # media_type = "getty_editorial_video"
# elsif asset_family == "Getty::GettyCreative"
  # media_type = "getty_creative_video"
# else
  # media_type = "istock_creative_video"
# end
# contribution_hash["media_type"] = media_type
