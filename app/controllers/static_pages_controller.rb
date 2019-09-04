class StaticPagesController < ApplicationController
  def home
    @questions = Question.newest.paginate page: params[:page], per_page: 5
  end
end
