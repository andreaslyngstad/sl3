set :output, "#{path}/log/cron.log"
env :GEM_PATH, ENV['GEM_PATH']

every :day, at: '11:30pm' do
  runner "Statistics.write_count"
end
every :day, at: "00:02am" do
  runner "Subscription.set_not_paid_not_active"
end
every :day, at: "01:58am" do
  runner "Subscription.send_email_two_weeks_overdue"
end
every :day, at: "02:58am" do
  runner "Subscription.one_month_overdue"
end
every :day, at: "03:58am" do
	runner "InvoiceSender.delete_old_files"
end
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
