module Training
  class WorkoutTemplateExercisesController < ApplicationController
    before_action :set_workout_template, only: :create
    before_action :set_template_exercise, only: %i[edit update destroy]

    def create
      @template_exercise = @workout_template.workout_template_exercises.new(template_exercise_params)

      if @template_exercise.save
        respond_with_template
      else
        respond_with_template(status: :unprocessable_entity)
      end
    end

    def edit
    end

    def update
      if @template_exercise.update(template_exercise_params)
        redirect_to training_workout_template_path(@workout_template), notice: "Exercise updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @template_exercise.destroy!
      respond_with_template(notice: "Exercise removed.")
    end

    private
      def set_workout_template
        @workout_template = Current.user.workout_templates.find(params[:workout_template_id])
      end

      def set_template_exercise
        @template_exercise = WorkoutTemplateExercise
                             .joins(:workout_template)
                             .where(workout_templates: { user_id: Current.user.id })
                             .find(params[:id])
        @workout_template = @template_exercise.workout_template
      end

      def template_exercise_params
        params.require(:workout_template_exercise).permit(:exercise_id, :target_sets, :target_reps, :target_weight, :notes)
      end

      def respond_with_template(notice: nil, status: :ok)
        @workout_template.reload
        @template_exercise = WorkoutTemplateExercise.new
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "template_exercises",
              partial: "training/workout_templates/exercises",
              locals: { workout_template: @workout_template, template_exercise: @template_exercise }
            ), status: status
          end
          format.html { redirect_to training_workout_template_path(@workout_template), notice: notice }
        end
      end
  end
end
