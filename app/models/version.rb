class Version < ActiveRecord::Base
  default_scope { order(name: :desc) }

  belongs_to :repository
  has_many :tasks

  validates :name, presence: true
  validates :repository, presence: true

  def open_tasks
    tasks.where("solved = ?", false)
  end

  def closed_tasks
    tasks.where("solved = ?", true)
  end

  def progress_in_percent
    percent = 0
    if tasks.count > 0 then
      percent = (closed_tasks.count.to_f / tasks.count) * 100
    end
    return percent
  end
end
