module Routine
  class TaskTemplatesController < ApplicationController
    before_action :set_task_template, only: %i[edit update destroy]

    def index
      @task_templates = Current.user.task_templates.ordered
    end

    def new
      @task_template = Current.user.task_templates.new
    end

    def create
      @task_template = Current.user.task_templates.new(task_template_params)

      if @task_template.save
        redirect_to routine_task_templates_path, notice: "Routine item added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @task_template.update(task_template_params)
        redirect_to routine_task_templates_path, notice: "Routine item updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @task_template.destroy!
      redirect_to routine_task_templates_path, notice: "Routine item removed.", status: :see_other
    end

    private
      def set_task_template
        @task_template = Current.user.task_templates.find(params[:id])
      end

      def task_template_params
        permitted = params.require(:task_template).permit(
          :title, :description, :category, :active, :frequency,
          :time_of_day, :important, :position, weekdays: []
        )
        weekdays = permitted.delete(:weekdays)
        permitted[:weekdays_mask] = weekdays_mask_from(weekdays) if weekdays
        permitted
      end

      # Convert an array of weekday keys (from checkboxes) into a bitmask.
      def weekdays_mask_from(weekdays)
        weekdays.compact_blank.sum do |day|
          bit = TaskTemplate::WEEKDAY_BITS[day.to_sym]
          bit ? (1 << bit) : 0
        end
      end
  end
end
