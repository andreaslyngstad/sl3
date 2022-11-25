require "support/active_record"
require "./lib/hash_diff.rb"

describe Hash do
  it "returns a:1, b:2" do
    a = {a:1,c:3,b:2}
    b = {a:1,b:2, d:4}
    a.diff_sq(b).should == {c:3, d:4}
  end
end