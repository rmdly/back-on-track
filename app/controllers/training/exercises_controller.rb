module Training
  class ExercisesController < ApplicationController
    before_action :set_exercise, only: %i[edit update destroy]

    def index
      @exercises = Current.user.exercises.ordered
    end

    def new
      @exercise = Current.user.exercises.new(active: true)
    end

    def create
      @exercise = Current.user.exercises.new(exercise_params)

      if @exercise.save
        redirect_to training_exercises_path, notice: "Exercise added."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @exercise.update(exercise_params)
        redirect_to training_exercises_path, notice: "Exercise updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @exercise.destroy!
      redirect_to training_exercises_path, notice: "Exercise removed.", status: :see_other
    end

    private
      def set_exercise
        @exercise = Current.user.exercises.find(params[:id])
      end

      def exercise_params
        params.require(:exercise).permit(:name, :exercise_type, :muscle_group, :equipment, :default_unit, :active, :notes)
      end
  end
end
