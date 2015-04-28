#!/usr/bin/env ruby

require 'rethinkdb'
require 'json'

include RethinkDB::Shortcuts

database_name = "esp_submission_develop"
table_name = "contributions"

conn = r.connect(:host => "localhost", :port => 28015)

database_list = r.db_list.run(conn)
r.db_create(database_name).run(conn) unless database_list.include?(database_name)

tables_list = r.db(database_name).table_list.run(conn)
if tables_list.include?(table_name)
  r.db(database_name).table_drop(table_name).run(conn)
  r.db(database_name).table_create(table_name).run(conn)
end

count = 0
File.open("contributions.json", "r") do |file|

  while((line = file.gets))

    line = line.force_encoding(Encoding::UTF_8)
    line.gsub!("\u0000", "")
    line.gsub!("\n", "")
    data = JSON.parse(line)

    count += 1

    begin
      r.db(database_name).table(table_name).insert(data).run(conn)
    rescue => e
      puts e.message
      puts line
    end

    if count == 1
      puts "Inserting record #{count} ..."
    elsif count % 100 == 0
      puts "Inserting record #{count} ..."
    end

  end

end

