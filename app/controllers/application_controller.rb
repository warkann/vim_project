class ApplicationController < ActionController::Base
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]
  before_action :give_access_to_add_record, except: [:index, :show]  

  protect_from_forgery with: :exception

  protected

    def configure_devise_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:role, :slug, :nickname, :user_img, :user_img_cache, :email, :password, :password_confirmation, :current_password) }
    end

  private

    # метод, который находит в таблице Tagging гема acts-as_taggable-on все записи
    # указанной модели и формирует хеш { tag_name => tag_count }, где имя и количество тегов
    # только для нужной модели
    def work_with_tags(name)

      # находим все записи относящиеся к нужной модели    
      list_of_records = Tagging.where('taggable_type = ?', name)

      # отбираем id тегов на записях, относящихся к нужной модели. Эти id понадобятся в дальнейшем
      # для подсчета количества тегов и нахождения их имени    
      list_of_tags_id = list_of_records.uniq.pluck(:tag_id)
      
      # инициализируем переменную для счетчика и хеш для конечного результата в виде {tag_name => tag_count}    
      counter = 0
      @tag_statistic = Hash.new
      
      list_of_tags_id.each do |t|
   
        # подсчитываем количество упоминаний тега в нужной модели, определяем его имя и пишем в хеш
        counter = list_of_records.where('tag_id = ?', t).count
        tag_name = Tag.find(t).name
        @tag_statistic.update( tag_name => counter)
    end

    # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      unless current_user == nil ||
              current_user.access_code == 111 || 
              current_user.access_code == 110 || 
              current_user.id == @plugin.user_id
        flash[:error] = "You can't do it"
        redirect_to root_path
      end
    end

    # даем разрешение на создание новых записей всем зарегестрированным пользователям
    def give_access_to_add_record
      redirect_to root_path if current_user.nil?
    end 
  end
end
