class Question < ApplicationRecord
  belongs_to :category
  belongs_to :user
  has_many :question_tags, dependent: :destroy
  has_many :tags, through: :question_tags

  validates :title, presence: true
  validates :content, presence: true

  scope :newest, -> { order created_at: :DESC }

  #test vote for question: change to answer later
  has_many :votes, dependent: :destroy

  def self.search(search)
    left_joins(:user, :category, :question_tags, :tags).
    where("lower(questions.title) LIKE :search
      OR lower(questions.content) LIKE :search
      OR lower(users.name) like :search
      OR lower(tags.name) like :search", search: "%#{search}%").uniq
  end
end
