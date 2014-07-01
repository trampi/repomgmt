module UsersHelper

	def user_name_or_nobody user
		if user.nil? then
			"Niemand"
		else
			user.name
		end
	end

end
