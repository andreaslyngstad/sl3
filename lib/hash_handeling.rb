class HashHandeling
  def values_difference(firm, plan)
    firm.keys.inject({}) do |memo, key|
      unless firm[key] == plan[key]
        unless plan[key].nil?
          memo[key] = plan[key] - firm[key]
        end     
      end
      memo
    end
  end
end