class Comment < ActiveRecord::Base
  default_scope { order(id: :desc) }

  belongs_to :user
  belongs_to :task
  validates :message, presence: true
  validates :user, presence: true
  validates :task, presence: true
end
