class Statistics < ActiveRecord::Base  
  def self.write_count
    stats = Statistics.new
    stats.users = User.count
    firms_by_sub = Firm.group(:plan_id).count
    stats.firms = firms_by_sub.values.sum
    stats.free = firms_by_sub.values[0]
    stats.bronze = firms_by_sub.values[1]
    stats.silver = firms_by_sub.values[2]
    stats.gold = firms_by_sub.values[3]
    stats.platinum = firms_by_sub.values[4]
    stats.logs = Log.count
    stats.customers = Customer.count
    stats.projects = Project.count
    stats.save!
  end
end
