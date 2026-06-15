module Routine
  class DailyTasksController < ApplicationController
    before_action :set_daily_task, only: %i[edit update destroy complete reopen skip]

    def create
      @daily_plan = DailyPlan.find_or_create_for(Current.user, parsed_date)
      @daily_task = @daily_plan.daily_tasks.build(daily_task_params)
      @daily_task.user = Current.user
      @daily_task.source = :manual

      if @daily_task.save
        respond_to do |format|
          format.turbo_stream { render_checklist_stream }
          format.html { redirect_to day_redirect_path, notice: "Task added." }
        end
      else
        @daily_plan = @daily_task.daily_plan
        respond_to do |format|
          format.turbo_stream { render_checklist_stream(status: :unprocessable_entity) }
          format.html { redirect_to day_redirect_path, alert: "Could not add task." }
        end
      end
    end

    def edit
    end

    def update
      if @daily_task.update(daily_task_params)
        redirect_to day_redirect_path, notice: "Task updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @daily_task.destroy!
      respond_with_checklist(notice: "Task removed.")
    end

    def complete
      @daily_task.complete!
      respond_with_checklist(notice: "Nice — small wins count.")
    end

    def reopen
      @daily_task.reopen!
      respond_with_checklist(notice: "Task reopened.")
    end

    def skip
      @daily_task.skip!(params[:skip_reason])
      respond_with_checklist(notice: "Skipped — good enough beats perfect.")
    end

    private
      def set_daily_task
        @daily_task = Current.user.daily_tasks.find(params[:id])
        @daily_plan = @daily_task.daily_plan
      end

      def daily_task_params
        params.require(:daily_task).permit(:title, :notes, :category, :important)
      end

      def parsed_date
        Date.iso8601(params[:date].to_s)
      rescue ArgumentError, Date::Error
        Date.current
      end

      def respond_with_checklist(notice:)
        respond_to do |format|
          format.turbo_stream { render_checklist_stream }
          format.html { redirect_to day_redirect_path, notice: notice }
        end
      end

      # Return to the day being viewed; today uses the canonical root path.
      def day_redirect_path
        date = @daily_plan.date
        date == Date.current ? root_path : day_path(date)
      end

      def render_checklist_stream(status: :ok)
        @daily_plan.reload
        @new_task = DailyTask.new
        render turbo_stream: turbo_stream.replace(
          "day_checklist",
          partial: "routine/daily_tasks/checklist",
          locals: { daily_plan: @daily_plan, new_task: @new_task }
        ), status: status
      end
  end
end
