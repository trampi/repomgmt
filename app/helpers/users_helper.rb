module UsersHelper
  def user_name_or_nobody(user)
    if user.nil?
      I18n.t('nobody')
    else
      user.name
    end
  end
end
