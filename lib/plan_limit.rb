class PlanLimit
  def over_limit?(firm, plan)
    unless plan.nil?
    plan <= firm
    end
  end
end