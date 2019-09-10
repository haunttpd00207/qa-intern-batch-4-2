module QuestionsHelper
  def select_category
    Category.all.map{|c| [c.name, c.id]}
  end

  def select_tag
    Tag.all.map{|t| [t.name, t.id]}
  end

  def question_count
    Question.count
  end

  def user_count
    User.count
  end
end
