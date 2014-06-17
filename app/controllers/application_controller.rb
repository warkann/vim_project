class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  
  protect_from_forgery with: :exception

  protected

  def configure_devise_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:slug, :nickname, :user_img, :user_img_cache, :email, :password, :password_confirmation, :current_password) }
  end

  private

# метод, который находит в таблице Tagging гема acts-as_taggable-on все записи
# указанной модели и формирует хеш { tag_name => tag_count }, где имя и количество тегов
# только для нужной модели
  def work_with_tags(name)
    @list_of_records = Tagging.where('taggable_type = ?', name)
    @list_of_tags_id = @list_of_records.uniq.pluck(:tag_id)
    
    counter = 0
    @tag_statistic = Hash.new
    
    @list_of_tags_id.each do |t|
      counter = @list_of_records.where('tag_id = ?', t).count
      tag_name = Tag.find(t).name
      @tag_statistic.update( tag_name => counter)
    end
  
  end
end
