class ApplicationController < ActionController::Base
  before_action :configure_devise_permitted_parameters, if: :devise_controller?
  after_action :spectate, only: [:create, :update, :destroy], unless: :devise_controller?
  before_action :give_access_to_add_record, except: [:index, :show, :search], unless: :devise_controller?

  protect_from_forgery with: :exception

  protected

    def configure_devise_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:nickname, :user_img, :user_img_cache,:username, :login, :email, :password, :password_confirmation) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:role, :slug, :nickname, :user_img, :user_img_cache, :email, :password, :password_confirmation, :current_password) }
    end

    # метод, отслеживающий создание, изменение и удаление записей
    # в зависимости от экшена, мы будем:
    # destroy - создаваем spectator без id записи, т.к. ее нет
    # create - сначала находим последнюю созданную в моделе запись, а потом сохраняем spectator, т.к. сразу после create id eще не доступен
    # update - просто создаем spectator

    def spectate
      if action_name == "destroy"
          Spectator.create(user_id: current_user.id,
                           s_model: controller_name.classify,
                           s_action: action_name)
        elsif action_name == "create"
          new_record = controller_name.classify.constantize.last
          Spectator.create(user_id: current_user.id,
                           s_model: controller_name.classify,
                           s_action: action_name,
                           s_record_id: new_record.id)
        elsif action_name == "update"
          Spectator.create(user_id: current_user.id,
                           s_model: controller_name.classify,
                           s_action: action_name,
                           s_record_id: controller_name.classify.constantize.friendly.find(params[:id]).id)
      end
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
  end

  # даем разрешение на создание новых записей всем зарегестрированным пользователям
  def give_access_to_add_record
    redirect_to plugins_path if !current_user
  end

  # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
  def check_permissions(record)
    unless !current_user ||
            current_user.access_code == 111 ||
            current_user.access_code == 110 ||
            current_user.id == record.user_id
      flash[:error] = "You can't do it"
      redirect_to plugins_path
    end
  end

end