class StaticPagesController < ApplicationController
  def home
    @questions = Question.newest
  end
end
