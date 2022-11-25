require "date"
require 'support/active_record'
require "./lib/logs_report.rb"
require "./lib/date_range.rb"
require File.expand_path(File.dirname(__FILE__) + "../../../app/models/log.rb")

describe LogsReport do
  before(:each) do
    @range = DateRange.new(Date.new(2012,12,17),Date.new(2012,12,23))
    @logs = [
    Log.new(:event =>"test", :log_date => Date.new(2012,12,16), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,17), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,18), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,19), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,20), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,21), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,21), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,22), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,22), :hours => 3600),
    Log.new(:event =>"test", :log_date => Date.new(2012,12,24), :hours => 3600)
    ]
  end
  it "returns the total hour of logs in range" do
    LogsReport.new(@logs,@range).total_hours_within_time_range.should == 28800
  end
 
end