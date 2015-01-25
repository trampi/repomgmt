class Version < ActiveRecord::Base
  default_scope { order(name: :desc) }

  belongs_to :repository
  has_many :tasks

  validates :name, presence: true
  validates :repository, presence: true

  def open_tasks
    tasks.where('solved = ?', false)
  end

  def closed_tasks
    tasks.where('solved = ?', true)
  end

  def progress_in_percent
    tasks.count > 0 ? (closed_tasks.count.to_f / tasks.count) * 100 : 0
  end
end
