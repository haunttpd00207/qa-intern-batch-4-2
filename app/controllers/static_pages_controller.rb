class StaticPagesController < ApplicationController
  def home
    @questions = Question.page(params[:page]).per(5).newest
  end
end
