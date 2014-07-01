module ApplicationHelper
	def all_repositories
		Repository.all
	end

	def all_users
		User.all
	end

	def is_repositories_controller?
		controller.controller_name == "repositories"
	end

	def is_users_controller?
		controller.controller_name == "users"
	end

	def is_statistics_controller?
		controller.controller_name.starts_with? "statistics"
	end

	def is_settings_controller?
		controller.controller_name.starts_with? "settings"
	end

	def is_projects_controller?
		return ["projects", "tasks", "versions"].any?{ |name| controller.controller_name.starts_with? name }
	end

	def human_boolean bool
		bool ? "Ja" : "Nein"
	end

end
