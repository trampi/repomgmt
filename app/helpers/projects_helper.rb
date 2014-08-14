module ProjectsHelper
	def task_class task
		if task.solved? then
			return "success"
		elsif task.in_progress? then
			return "warning"
		else
			return "danger"
		end
	end

	def is_id_in_params symbol, id
		params.fetch(symbol, []).find_index { |index_as_string| id.to_s == index_as_string } != nil
	end

	def task_is_version_checked version
		is_id_in_params(:version, version.id)
	end

	def task_is_assignee_checked user
		is_id_in_params(:assignee, user.id)
	end

	def task_is_author_checked user
		is_id_in_params(:author, user.id)
	end
end
