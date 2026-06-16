module Training
  class WorkoutExercisesController < ApplicationController
    before_action :set_workout_session, only: :create
    before_action :set_workout_exercise, only: :destroy

    def create
      @workout_exercise = @workout_session.workout_exercises.new(workout_exercise_params)
      @workout_exercise.position = @workout_session.workout_exercises.count

      if @workout_exercise.save
        render_session
      else
        render_session(status: :unprocessable_entity)
      end
    end

    def destroy
      @workout_exercise.destroy!
      render_session
    end

    private
      def set_workout_session
        @workout_session = Current.user.workout_sessions.find(params[:workout_session_id])
      end

      def set_workout_exercise
        @workout_exercise = WorkoutExercise
                            .joins(:workout_session)
                            .where(workout_sessions: { user_id: Current.user.id })
                            .find(params[:id])
        @workout_session = @workout_exercise.workout_session
      end

      def workout_exercise_params
        params.require(:workout_exercise).permit(:exercise_id, :notes)
      end

      def render_session(status: :ok)
        @workout_session.reload
        @workout_exercise = WorkoutExercise.new
        render turbo_stream: turbo_stream.replace(
          "workout_body",
          partial: "training/workout_sessions/session_body",
          locals: { workout_session: @workout_session, new_workout_exercise: @workout_exercise }
        ), status: status
      end
  end
end
