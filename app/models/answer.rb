class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question
  has_many :votes, dependent: :destroy

  validates :content, presence: true

  scope :newest, -> { order created_at: :DESC }
end
