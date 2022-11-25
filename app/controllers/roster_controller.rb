class RosterController < ApplicationController
  def get_milestones
    @milestones = Milestone.user_milestones_two_weeks(current_firm, current_user)
    respond_to do |format|
      format.js
    end
  end
  def get_tasks
    @tasks_overdue_and_to_day = current_user.todos.overdue_and_to_day
    respond_to do |format|
      format.js
    end
  end
end