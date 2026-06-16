module Training
  class PlannedWorkoutsController < ApplicationController
    before_action :set_planned_workout, only: %i[destroy start]

    def create
      @planned_workout = Current.user.planned_workouts.new(planned_workout_params)
      @planned_workout.weekly_plan = WeeklyPlan.current_for(Current.user, @planned_workout.planned_on) if @planned_workout.planned_on
      apply_template_name

      if @planned_workout.save
        redirect_back fallback_location: day_path(@planned_workout.planned_on), notice: "Workout planned."
      else
        redirect_back fallback_location: root_path, alert: "Could not plan workout."
      end
    end

    # Begin an actual session from a planned workout.
    def start
      session = Current.user.workout_sessions.create!(
        workout_template: @planned_workout.workout_template,
        planned_workout: @planned_workout,
        performed_on: Date.current,
        started_at: Time.current,
        name: @planned_workout.name
      )
      session.populate_from_template!
      redirect_to training_workout_session_path(session)
    end

    def destroy
      @planned_workout.destroy!
      redirect_back fallback_location: root_path, notice: "Planned workout removed.", status: :see_other
    end

    private
      def set_planned_workout
        @planned_workout = Current.user.planned_workouts.find(params[:id])
      end

      def planned_workout_params
        params.require(:planned_workout).permit(:planned_on, :name, :workout_template_id, :notes)
      end

      def apply_template_name
        return if @planned_workout.name.present?

        template = Current.user.workout_templates.find_by(id: @planned_workout.workout_template_id)
        @planned_workout.name = template.name if template
      end
  end
end
