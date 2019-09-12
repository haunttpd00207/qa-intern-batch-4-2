class QuestionsController < ApplicationController
  before_action :load_question, except: [:index, :new, :create, :autofilltext]
  before_action :load_vote, only: [:unvote]
  before_action :correct_user, only: [:edit, :update, :destroy]
  before_action :logged_in_user, except: [:index, :show, :autofilltext]

  def index
    @questions = current_user.questions.newest.paginate page: params[:page], per_page: 5
  end

  def show
    rows = @question.answers.newest.includes(:user)
    @answers = Kaminari.paginate_array(rows).page(params[:page]).per(5)
    @answer = @question.answers.build
    @comments = @question.comments.newest.includes(:user)
    @comment = @question.comments.build
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
    if @question.update question_params
      redirect_to @question, success: "Updating are successful!"
    else
      render :edit
    end
  end

  def destroy
    @question.destroy
    redirect_to questions_path, success: "Deleting are successful!"
  end

  def upvote
    if already_voted?
      flash[:info] = "You can't vote more than once"
    else
      @question.votes.create user_id: current_user.id
      flash[:info] = "Thank for voting"
    end
      redirect_to question_path @question
  end

  def unvote
    if !(already_voted?)
      flash[:info] = "Can not unvoted the thing you did not vote"
    else
      @vote.destroy
      flash[:info] = "Thank for unvoting"
    end
      redirect_to question_path @question
  end

  def search
    if params[:search].blank?
      redirect_to root_path, info: "Please typing any thing on search bar"
    else
      @results = Question.left_joins(:user, :category, :question_tags, :tags).search params[:search]
    end
  end

  def autofilltext
    @all = Question.search(params[:search]).map(&:title)
    render json: @all.uniq.sort
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

  def load_vote
    @vote = @question.votes.find_by user_id: current_user.id
    return if @vote
    redirect_to root_path, danger: "Vote Errors"
  end

  def correct_user
    return if current_user?(@question.user)
    redirect_to root_path, danger: "No Permission"
  end

  def already_voted?
    @question.votes.where(user_id: current_user.id).exists?
  end
end
