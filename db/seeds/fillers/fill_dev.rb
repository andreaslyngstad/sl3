f = Firm.find_by_name("Lekk betong")
300.times do |n|
   p = Project.new(name: "pro" + (n + 1).to_s, active:true)
   p.firm = f
   p.save 
end
300.times do |n|
   p = Customer.new(name: "cust" + (n + 1).to_s)
   p.firm = f
   p.save 
end