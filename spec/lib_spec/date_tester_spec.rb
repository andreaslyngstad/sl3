require "support/active_record"
require "./lib/date_tester.rb"

describe DateTester do
  it "returns false when not given a date" do
    false_time = ["13.13.2013", "13/13/2013", '06152008']
    false_time.each do |p|
      DateTester.new.date?(p).should be_false
    end
  end
  it "returns true when not given a date" do
    correct_time = ["2013-03-03", "2013.12.13", "13.12.2013", "11/13/2013", '20080615', 'Sun, 16 Jun 2008', '16 Jun 2008']
    correct_time.each do |p|
      DateTester.new.date?(p).should be_true
    end
  end
end