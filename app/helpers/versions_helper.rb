module VersionsHelper

	def version_row_class version
		return "text-muted" if version.delivered?
		return "danger" if not version.due_date.nil? and version.due_date.past?
		return ""
	end

	def version_if_set version
		if version then
			version.name
		else
			return "Keine"
		end
	end

end
