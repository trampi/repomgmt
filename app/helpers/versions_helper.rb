module VersionsHelper
  def version_row_class(version)
    return 'text-muted' if version.delivered?
    return 'danger' if !version.due_date.nil? && version.due_date.past?
  end

  def version_if_set(version)
    if version
      version.name
    else
      return 'Keine'
    end
  end
end
