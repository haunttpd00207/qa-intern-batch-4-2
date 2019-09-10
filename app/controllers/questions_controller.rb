class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create]

  def index; end

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

  private

  def question_params
    params.require(:question).permit :category_id, :title, :content, tag_ids: []
  end
end
