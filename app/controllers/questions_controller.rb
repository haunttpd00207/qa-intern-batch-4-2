class QuestionsController < ApplicationController
  before_action :load_question, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user

  def show; end

  def index
    @questions = current_user.questions.newest
  end

  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new question_params
    if @question.save
      redirect_to root_path, success: "Create successfully!"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @question.update_attributes(question_params)
      redirect_to @question, success: "Updating are successful!"
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, success: "Deleting are successful!"
  end

  private

  def question_params
    params.require(:question).permit :category_id, :title, :content, tag_ids: []
  end

  def load_question
    @question = Question.find_by id: params[:id]
    return if @question
    redirect_to root_path, danger: "Question Errors"
  end

  def correct_user
    @question = current_user.questions.find_by(id: params[:id])
    redirect_to root_path, danger: "No Permission" if @question.nil?
  end
end
