module ApplicationHelper
  def full_title(page_title = '')
    base_title = "QA ENGINE"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def tag_hot
    tags = QuestionTag.joins(:tag).group(:name).count.sort_by {|name,total| total}.reverse
  end

  def count_comment question
    question.comments.where(answer_id: nil).count
  end

  def select_comments comments, answer_id
    comments.select { |c| c.answer_id === answer_id }
  end
end
