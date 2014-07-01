module StatisticsRepositoriesHelper

	def repository_statistics_link repository
		if current_user.admin? then
		 	admin_statistics_repository_path repository 
		else
			statistics_repository_path repository 
		end
	end

end
