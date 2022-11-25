require 'open-uri'
open('customers') do |customers|  
  File.open('customers_ready', 'w') do |f2|  
  customers.read.each_line do |customer|
    n = customer.chomp.split("|")
    f2.puts "country: " + n
  end  
end  
end  
 