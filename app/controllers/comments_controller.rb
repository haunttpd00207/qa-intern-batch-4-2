class CommentsController < ApplicationController
  before_action :logged_in_user
  before_action :load_question, only: :create
  before_action :load_comment, only: [:edit, :update, :destroy]

  def create
    @comment = @question.comments.build comment_params
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.js
    end
  end

  def edit
    respond_to do |format|
      format.js
    end
  end

  def update
    @comment.update comment_params
    respond_to do |format|
      format.js
    end
  end

  def destroy
    @comment.destroy
    respond_to do |format|
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit :content, :answer_id
  end

  def load_comment
    @comment = Comment.find_by id: params[:id]
    return if @comment
    redirect_to root_path, danger: "Comment not found"
  end

  def load_question
    @question = Question.find_by id: params[:question_id]
    return if @question
    redirect_to root_path, danger: "Question not found"
  end
end
