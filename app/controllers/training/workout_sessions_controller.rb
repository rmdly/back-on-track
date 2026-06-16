module Training
  class WorkoutSessionsController < ApplicationController
    before_action :set_workout_session, only: %i[show destroy finish]

    def index
      @workout_sessions = Current.user.workout_sessions.recent
    end

    def new
      @workout_session = Current.user.workout_sessions.new(performed_on: Date.current)
      @workout_templates = Current.user.workout_templates.active.ordered
    end

    def create
      @workout_session = Current.user.workout_sessions.new(workout_session_params)
      @workout_session.performed_on ||= Date.current
      @workout_session.started_at = Time.current
      apply_template

      if @workout_session.save
        @workout_session.populate_from_template!
        redirect_to training_workout_session_path(@workout_session), notice: "Workout started."
      else
        @workout_templates = Current.user.workout_templates.active.ordered
        render :new, status: :unprocessable_entity
      end
    end

    def show
      @workout_exercise = WorkoutExercise.new
    end

    def finish
      @workout_session.update!(completed_at: Time.current)
      @workout_session.planned_workout&.completed!
      redirect_to training_workout_session_path(@workout_session), notice: "Workout finished. Good effort."
    end

    def destroy
      @workout_session.destroy!
      redirect_to training_workout_sessions_path, notice: "Workout deleted.", status: :see_other
    end

    private
      def set_workout_session
        @workout_session = Current.user.workout_sessions.find(params[:id])
      end

      def workout_session_params
        params.require(:workout_session).permit(:name, :performed_on, :notes, :workout_template_id)
      end

      # Validate template ownership and snapshot its name.
      def apply_template
        return if @workout_session.workout_template_id.blank?

        template = Current.user.workout_templates.find(@workout_session.workout_template_id)
        @workout_session.name = template.name if @workout_session.name.blank?
      end
  end
end
