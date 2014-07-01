class Task < ActiveRecord::Base
	belongs_to :version
	belongs_to :author, class_name: "User"
	belongs_to :assignee, class_name: "User"
	belongs_to :repository
	has_many :comments, dependent: :destroy

	validates :repository, presence: true
	validates :title, presence: true
	validates :author, presence: true

	def in_progress?
		return ! assignee.nil? && ! solved?
	end

	def not_assigned?
		return ! in_progress? && ! solved?
	end
end
