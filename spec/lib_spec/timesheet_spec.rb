require "date"
require 'support/active_record'
require "./lib/logs_report.rb"
require "./lib/date_range.rb"
require File.expand_path(File.dirname(__FILE__) + "../../../app/models/log.rb")

describe LogsReport do
  it "returns the logs in range" do
    log1 = Log.new(:event =>"test", :log_date => Date.new(2012,12,17), :hours => 3600)
    log2 = Log.new(:event =>"test", :log_date => Date.new(2012,12,22), :hours => 3600)
    logs = [log1,log2]
    range = DateRange.new(Date.new(2012,12,17),Date.new(2012,12,21))
    LogsReport.new(logs,range).total_hours_within_time_range.should == 3600
  end
end