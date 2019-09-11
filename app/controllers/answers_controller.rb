class AnswersController < ApplicationController
  before_action :logged_in_user
  before_action :load_question, expect: [:show, :new]
  before_action :load_comment, only: [:create, :update, :destroy]
  before_action :load_answer, only: [:edit, :update, :destroy]

  def index
    rows = @question.answers.newest.includes(:user)
    @answers = Kaminari.paginate_array(rows).page(params[:page]).per(5)
    @answer = @question.answers.build
    @comments = @question.comments.newest.includes(:user)
    @comment = @question.comments.build
  end

  def create
    @answer = @question.answers.build answer_params
    @answer.user_id = current_user.id
    @answer.save
    rows = @question.answers.newest
    @answers = Kaminari.paginate_array(rows).page(params[:page]).per(5)
    respond_to do |format|
      format.js
    end
  end

  def edit; end

  def update
    @answer.update answer_params
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @answer.destroy
    rows = @answer.question.answers.newest
    @answers = Kaminari.paginate_array(rows).page(params[:page]).per(5)
    respond_to do |format|
      format.js
    end
  end

  private

  def answer_params
    params.require(:answer).permit :content
  end

  def load_answer
    @answer = Answer.find_by id: params[:id]
    return if @answer
    redirect_to root_path, danger: "Answer not found"
  end

  def load_question
    @question = Question.find_by id: params[:question_id]
    return if @question
    redirect_to root_path, danger: "Question not found"
  end

  def load_comment
    @comment = @question.comments.build
    @comments = @question.comments.newest.includes(:user)
  end
end
