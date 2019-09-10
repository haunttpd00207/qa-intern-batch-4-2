module ApplicationHelper
  def full_title(page_title = '')
    base_title = "QA ENGINE"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end

  def tag_all
    Tag.all
  end

  def voted?(question)
    question.votes.find_by user_id: current_user.id
  end
end
