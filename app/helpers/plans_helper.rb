module PlansHelper
  def current_plan
    current_firm.plan
  end
  def current_plan?(plan)
    current_plan == plan
  end
  def current_plan_style(plan)
    if current_plan?(plan)
       "blue"
    end 
  end
end

