#video seeds

class Array
  def / len
  a = []
  each_with_index do |x,i|
  a << [] if i % len == 0
  a.last << x
  end
  a
  end
end# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

#!/bin/env ruby
Firm.delete_all
Log.delete_all
Plan.delete_all
Customer.delete_all
Project.delete_all
User.delete_all
Employee.delete_all
Log.delete_all
Invoice.delete_all

Plan.create! name: "Free", price: 0, customers: 2, logs: 100, projects: 2, users:2, paymill_id: '12', currency: '$'
Plan.create! name: "Bronze", price: 19, customers: nil, logs: nil, projects: 50, users:10, paymill_id: '12', currency: '$'
Plan.create! name: "Silver", price: 49, customers: nil, logs: nil, projects: 200, users:30, paymill_id: '12', currency: '$'
gold_plan = Plan.create! name: "Gold", price: 99, customers: nil, logs: nil, projects: 400, users:100, paymill_id: '12', currency: '$'
Plan.create! name: "Platinum", price: 199, customers: nil, logs: nil, projects: nil, users:nil, paymill_id: '12', currency: '$'

puts "Plans added"
puts "setting up first firm"
firm1 = Firm.create! name: "Lizz", 
                      subdomain: "lizz", 
                      plan_id: gold_plan.id, currency: "USD",
                      language: "en-US",
                      time_zone: "Berlin",
                      tax: 25.0,
                      reminder_fee: 50.0,
                      bank_account: '123',
                      vat_number: '123',
                      time_format: 1,
                      date_format: 1,
                      clock_format: 1

puts 'New firm created: ' << firm1.name
puts 'SETTING UP EXAMPLE USERS'
user1 = User.new :name => 'Andreas Lyngstad', hourly_rate: 1000.0, :email => 'andreas@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user1.firm = firm1
user1.save
puts 'New user created: ' << user1.name
user2 = User.new :name => 'Agnes Whittington', :email => 'agnes@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user2.firm = firm1
user2.save
puts 'New user created: ' << user2.name
user3 = User.new :name => 'Christoffer Banes', :email => 'cristoffer@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user3.firm = firm1
user3.save
puts 'New user created: ' << user3.name
user4 = User.new :name => 'Dorian Gaughan', :email => 'dorian@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user4.firm = firm1
user4.save
puts 'New user created: ' << user4.name
user5 = User.new :name => 'Jeanett Meaux', :email => 'jeanett@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user5.firm = firm1
user5.save
puts 'New user created: ' << user5.name
user6 = User.new :name => 'Rodney	Willis', :email => 'jeanett@squadlink.com', :password => 'lekmedmeg', :password_confirmation => 'lekmedmeg', :role => "Admin"
user6.firm = firm1
user6.save
puts 'New user created: ' << user6.name

puts "Setting up customers"
first_customer = Customer.new(:name => "Thomas Cushman")
first_customer.firm = firm1
first_customer.email = "thomas@cushman.com"
first_customer.save
    
    puts "Made customer : "<< first_customer.name

open("db/seeds/customers") do |customers|
  customers.read.each_line do |customer|
    customer_made = Customer.new(:name => customer.gsub(/\t/, ' ').rstrip)
    customer_made.firm = firm1
    customer_made.email = "andreaslyngstad@gmail.com"
    customer_made.save
    
    puts "Made customer : "<< customer_made.name
end
end
puts "Setting up Employees"

puts "Setting up projects"
projects1 = Project.new :name => "Website - Thomas Cushman", :description => "Simple site that displays the firm in a good way" , :active => true, budget: 10000, customer: first_customer
projects1.firm = firm1
projects1.save
Membership.create!(:user_id => user1.id, :project_id => projects1.id) 
Membership.create!(:user_id => user2.id, :project_id => projects1.id)
Membership.create!(:user_id => user3.id, :project_id => projects1.id)
Membership.create!(:user_id => user4.id, :project_id => projects1.id)
open("db/seeds/video_projects") do |projects|
  projects.read.each_line do |project|
    
    n = project.chomp.split("|")
    c = n[0]
    p = n[1]
    
    projects_made = Project.new(:name => c, :description => p , :active => true)
    projects_made.firm = firm1
    projects_made.save
    puts "Made Project : " << projects_made.name
    Membership.create!(:user_id => user1.id, :project_id => projects_made.id)
    
  end
end

puts "Setting up todos"
todo1 = Todo.create! customer: first_customer, :user_id => user1.id, firm: firm1, :name => "Call Thomas and find a time for a meeting", project: projects1, :due => Time.now, :completed => false
puts 'New todo created: ' << todo1.name
todo2 = Todo.create! customer: first_customer, :user_id => user1.id, firm: firm1, :name => "Have a initial chat with Thomas about his goals for the initinfo webpage.", project: projects1, :due => Time.now + 1.day, :completed => false
puts 'New todo created: ' << todo2.name
todo3 = Todo.create! customer: first_customer, :user_id => user4.id, firm: firm1, :name => "Presentation of the first design ideas.", project: projects1, :due => Time.now + 10.days, :completed => false
puts 'New todo created: ' << todo3.name
todo4 = Todo.create! customer: first_customer, :user_id => user1.id, firm: firm1, :name => "Close the deal and agree on price.", project: projects1, :due => Time.now + 3.days, :completed => false
puts 'New todo created: ' << todo4.name
todo5 = Todo.create! customer: first_customer, :user_id => user2.id, firm: firm1, :name => "Make SEO", project: projects1, :due => Time.now + 24.days, :completed => false
puts 'New todo created: ' << todo5.name
todo6 = Todo.create! customer: first_customer, :user_id => user3.id,firm: firm1, :name => "Bug fixing.", project: projects1, :due => Time.now + 11.days, :completed => false
puts 'New todo created: ' << todo6.name
todo7 = Todo.create! customer: first_customer, :user_id => user3.id,firm: firm1, :name => "Fit the content into the design.", project: projects1, :due => Time.now + 17.days, :completed => false
puts 'New todo created: ' << todo7.name
todo8 = Todo.create! customer: first_customer, :user_id => user2.id,firm: firm1, :name => "Finish the project.", project: projects1, :due => Time.now + 27.days, :completed => false
puts 'New todo created: ' << todo8.name
todo9 = Todo.create! customer: first_customer, :user_id => user4.id,firm: firm1, :name => "Set up two initial designs.", project: projects1, :due => Time.now + 7.days, :completed => false
puts 'New todo created: ' << todo9.name
# todos = [todo1,todo2,todo3,todo4,todo5, todo6, todo7,todo8,todo9]
# todos.each do |todo|
#   todo.firm = firm1
#   todo.save
# end

puts "Setting up logs"
time4daysago = Time.zone.today - 4.days
time6daysago = Time.zone.today - 6.days
timeyesterday = Time.zone.today - 1.days
today = Time.zone.today - 1.days + 1.days

module SeedHelpers
def time_setter(hours)
	Time.now.beginning_of_day - hours.hours
end
end
include SeedHelpers
firm1.logs.new(customer: first_customer, :user_id => user4.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(-8), 	:begin_time => SeedHelpers.time_setter(-4), :end_time => SeedHelpers.time_setter(-8.5), :event => "Started on a conservative design.").save
firm1.logs.new(customer: first_customer, :user_id => user4.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(-8), 	:begin_time => SeedHelpers.time_setter(-9), :end_time => SeedHelpers.time_setter(-12.5), :event => "Finishing up the conservative design").save
firm1.logs.new(customer: first_customer, :user_id => user4.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(8),  	:begin_time => SeedHelpers.time_setter(8),  :end_time => SeedHelpers.time_setter(6), :event => "Set up Radical design").save
firm1.logs.new(customer: first_customer, :user_id => user4.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(37), 	:begin_time => SeedHelpers.time_setter(37), :end_time => SeedHelpers.time_setter(33), :event => "Last touches on the radical design").save
firm1.logs.new(customer: first_customer, :user_id => user1.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo2.id, :tracking => false, :log_date => SeedHelpers.time_setter(-8),	:begin_time => SeedHelpers.time_setter(-8.6), :end_time => SeedHelpers.time_setter(-16.1), :event => "Talked with Thomas and Robert on the phone.").save
firm1.logs.new(customer: first_customer, :user_id => user2.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo2.id, :tracking => false, :log_date => SeedHelpers.time_setter(16), 	:begin_time => SeedHelpers.time_setter(16), :end_time => SeedHelpers.time_setter(14), :event => "Phone conference with Mr Cushman & son").save
firm1.logs.new(customer: first_customer, :user_id => user1.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo4.id, :tracking => false, :log_date => SeedHelpers.time_setter(-8), 	:begin_time => SeedHelpers.time_setter(-8.2),  :end_time => SeedHelpers.time_setter(-14.2), :event => "Thomas agrees on price").save
firm1.logs.new(customer: first_customer, :user_id => user3.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo6.id, :tracking => false, :log_date => SeedHelpers.time_setter(8), 	:begin_time => SeedHelpers.time_setter(8),  :end_time => SeedHelpers.time_setter(6), :event => "Problems in the image viewer"  ).save
firm1.logs.new(customer: first_customer, :user_id => user3.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo6.id, :tracking => false, :log_date => SeedHelpers.time_setter(8), 	:begin_time => SeedHelpers.time_setter(8),  :end_time => SeedHelpers.time_setter(6), :event => "Minor HTML fixes").save
firm1.logs.new(customer: first_customer, :user_id => user2.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(40), 	:begin_time => SeedHelpers.time_setter(40), :end_time => SeedHelpers.time_setter(36), :event => "Convertion to saas").save
firm1.logs.new(customer: first_customer, :user_id => user2.id, rate: 100.0, :project_id => projects1.id, :todo_id => todo9.id, :tracking => false, :log_date => SeedHelpers.time_setter(50), 	:begin_time => SeedHelpers.time_setter(50), :end_time => SeedHelpers.time_setter(46), :event => "Convertion to saas").save
customers = Customer.limit(15)
a = []
customers.each {|c| a << c.id}

100.times do |n|
  n + 1
random = rand(30.days).seconds.ago
random_prize = rand(150.50..3500.50)


log = firm1.logs.new :user => User.order("RANDOM()").first, 
rate: 100.0, 
customer:  Customer.find(a.sample),
:project => Project.order("RANDOM()").first, 
:tracking => false, 
:log_date => random,  
:begin_time => random, 
:end_time => random + (rand(1.00..5.00).hours), 
:event => "Started on a conservative design."
log.save
puts (100 - n).to_s + " -- log --"
end


puts "Setting up milestones"
milestone1 = Milestone.new :goal => "Get the project", :project_id => projects1.id, :due => Time.now + 3000000, :completed => false
milestone1.firm = firm1
milestone1.save
puts 'New milestone created: ' << milestone1.goal
milestone2 = Milestone.new :goal => "Finished design", :project_id => projects1.id, :due => Time.now + 3100000, :completed => false
milestone2.firm = firm1
milestone2.save
puts 'New milestone created: ' << milestone2.goal
milestone3 = Milestone.new :goal => "Done with content", :project_id => projects1.id, :due => Time.now + 3200000, :completed => false
milestone3.firm = firm1
milestone3.save
puts 'New milestone created: ' << milestone3.goal
milestone4 = Milestone.new :goal => "Get the money", :project_id => projects1.id, :due => Time.now + 3400000, :completed => false
milestone4.firm = firm1
milestone4.save
puts 'New milestone created: ' << milestone4.goal

100.times do |n|
  n + 1
random = rand(1.years).seconds.ago
random_prize = rand(150.50..3500.50)
invoice = Invoice.new status:       6, 
customer:     Customer.order("RANDOM()").first, 
number:       n,
total:        random_prize,
paid:         random,
paid_amount:  random_prize,
date:         random, 
due:          random
invoice.firm = firm1
invoice.save
puts (100 - n).to_s + " -- invoice --"
end


