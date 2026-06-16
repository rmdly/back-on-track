module Training
  class WorkoutSetsController < ApplicationController
    before_action :set_workout_exercise, only: :create
    before_action :set_workout_set, only: %i[update destroy complete duplicate]

    def create
      @workout_set = @workout_exercise.workout_sets.new(workout_set_params)
      @workout_set.position = @workout_exercise.workout_sets.count
      @workout_set.save
      render_session
    end

    def update
      @workout_set.update(workout_set_params)
      render_session
    end

    def complete
      @workout_set.complete!
      render_session
    end

    # Add a new set copying the weight/reps of this one — fast repeat logging.
    def duplicate
      @workout_exercise.workout_sets.create!(
        weight: @workout_set.weight,
        reps: @workout_set.reps,
        rpe: @workout_set.rpe,
        position: @workout_exercise.workout_sets.count
      )
      render_session
    end

    def destroy
      @workout_set.destroy!
      render_session
    end

    private
      def set_workout_exercise
        @workout_exercise = scoped_workout_exercises.find(params[:workout_exercise_id])
        @workout_session = @workout_exercise.workout_session
      end

      def set_workout_set
        @workout_set = WorkoutSet
                       .joins(workout_exercise: :workout_session)
                       .where(workout_sessions: { user_id: Current.user.id })
                       .find(params[:id])
        @workout_exercise = @workout_set.workout_exercise
        @workout_session = @workout_exercise.workout_session
      end

      def scoped_workout_exercises
        WorkoutExercise.joins(:workout_session).where(workout_sessions: { user_id: Current.user.id })
      end

      def workout_set_params
        params.require(:workout_set).permit(:weight, :reps, :rpe, :distance, :duration_seconds, :notes)
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
