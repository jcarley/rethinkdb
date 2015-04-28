#!/usr/bin/env ruby

require 'json'

count = 0

input_file = File.open("contributions.json", "r")
output_file = File.open("contributions_out.json", "w")
error_file = File.open("contributions_errors.json", "w")

while((line = input_file.gets))

  count += 1

  if line.match(/\\u0000/)
    puts "=========== found a bad line (#{count}) ================="
    error_file.write(line)
  else
    output_file.write(line)
  end

    if count == 1
      puts "Cleaning record #{count} ..."
    elsif count % 100 == 0
      puts "Cleaning record #{count} ..."
    end
end

input_file.flush
output_file.flush
error_file.flush

input_file.close
output_file.close
error_file.close

