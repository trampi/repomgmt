module ProjectsHelper
  def task_class(task)
    return 'success' if task.solved?
    return 'warning' if task.in_progress?
    'danger'
  end

  def id_in_params?(symbol, id)
    params.fetch(symbol, []).find_index { |index_as_string| id.to_s == index_as_string } != nil
  end

  def task_is_version_checked(version)
    id_in_params?(:version, version.id)
  end

  def task_is_assignee_checked(user)
    id_in_params?(:assignee, user.id)
  end

  def task_is_author_checked(user)
    id_in_params?(:author, user.id)
  end
end
