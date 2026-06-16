module Training
  class WorkoutTemplatesController < ApplicationController
    before_action :set_workout_template, only: %i[show edit update destroy]

    def index
      @workout_templates = Current.user.workout_templates.ordered
    end

    def show
      @template_exercise = WorkoutTemplateExercise.new
    end

    def new
      @workout_template = Current.user.workout_templates.new(active: true)
    end

    def create
      @workout_template = Current.user.workout_templates.new(workout_template_params)

      if @workout_template.save
        redirect_to training_workout_template_path(@workout_template), notice: "Workout template created. Add exercises below."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @workout_template.update(workout_template_params)
        redirect_to training_workout_template_path(@workout_template), notice: "Workout template updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @workout_template.destroy!
      redirect_to training_workout_templates_path, notice: "Workout template removed.", status: :see_other
    end

    private
      def set_workout_template
        @workout_template = Current.user.workout_templates.find(params[:id])
      end

      def workout_template_params
        params.require(:workout_template).permit(:name, :description, :active)
      end
  end
end
