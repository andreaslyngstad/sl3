module TodoHelper
 def todo_priority(prior)
 	  case
 	  when prior == 3
 	    "todo_red"
 	  when prior == 2
 	    "todo_yellow"
 	  when prior == 1
 	    "todo_green"
 	  end
 	end 
 	def done_not_done(done_todos, not_done_todos)
  	done = done_todos.count
  	not_done = not_done_todos.count	
  	donepr = (done / (done + not_done).to_f)*100
  	not_donepr = (not_done / (done + not_done).to_f)*100
  	donepr.round(2).to_s + "%"
  end
end