class AnswersController < ApplicationController
  before_action :logged_in_user
  before_action :load_answer, only: [:edit, :update, :destroy, :vote, :unvote]
  before_action :load_question, only: :create
  before_action :load_comment, only: [:create, :update, :destroy]
  before_action :load_vote, only: :unvote

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

  def vote
    if already_voted?
      flash[:info] = "You can't vote more than once"
    else
      @answer.votes.create user_id: current_user.id
      flash[:info] = "Thank for voting"
    end
      redirect_to request.referrer
  end

  def unvote
    if !(already_voted?)
      flash[:info] = "Can not unvoted the thing you did not vote"
    else
      @vote.destroy
      flash[:info] = "Thank for unvoting"
      redirect_to request.referrer
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

  def load_vote
    @vote = @answer.votes.find_by user_id: current_user.id
    return if @vote
    redirect_to root_path, danger: "Vote Errors"
  end

  def already_voted?
    @answer.votes.where(user_id: current_user.id).exists?
  end
end
