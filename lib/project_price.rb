class ProjectPrice
	def self.get_hours(project)
		project.logs.group("rate").sum(:hours).map {|k,v| k * v/3600}.inject(:+).try(:round, 2) 
	end

	# def self.get_cost_per_user(project)
	# 	# fiks bruk rate fra
	# 	project.logs.group("user").group("rate").sum(:hours).map {|k,v| [k[1],k[0], (k[0]*v/3600).round(2) ]}
	# end

	def self.set_procentage(project)
		used = ProjectPrice.get_hours(project) || 0  
		budget =  project.budget || 0 
		if used > 0 && budget > 0
			(used / budget).round(2)
		elsif budget == 0
			10000
		elsif used == 0
			20000
		end

	end
end