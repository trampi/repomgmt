module DeviseHelper
  delegate :admin?, to: :current_user

  def devise_error_messages!
    return '' if resource.errors.empty?
    messages = build_messages resource
    sentence = build_sentence resource
    build_html_error_message(sentence, messages).html_safe
  end

  private

  def build_messages(resource)
    resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
  end

  def build_sentence(resource)
    I18n.t('errors.messages.not_saved',
           count: resource.errors.count,
           resource: resource.class.model_name.human.downcase)
  end

  def build_html_error_message(sentence, messages)
    <<-HTML
        <div class="alert alert-danger text-center">
            <button type="button" class="close" data-dismiss="alert">x</button>
            <h4>#{sentence}</h4>
            #{messages}
        </div>
    HTML
  end
end
