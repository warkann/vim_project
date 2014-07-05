class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :user_present?
  before_action :user_admin?, only: [:edit, :update, :destroy, :view_log]

	def index
	end

	def edit
	end

	def update
		# обновляем поле access_code. user_params содержит одно значение - value из drop-box'a вьюхи user/edit
		@user.update(user_params)
		redirect_to @user
	end

	def show
	end

	def destroy
		if @user != current_user
			@user.destroy
			redirect_to root_path
		else
			flash[:error] = "Not possible"
		end
	end

  def view_log
  	@log_item = Spectator.order('created_at ASC')
  end

  def view_plugins_list
    @list_of_user_plugins = User.build_plugins_list(current_user)
  end

  def create_dotfile
    User.build_user_directory(current_user)
    if User.file_exist?(current_user)
      redirect_to request.referer
    else
      dotfile = User.build_user_dotfile(current_user)
      send_file dotfile
    end
  end

  private

    def set_user
      @user = User.friendly.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:access_code)
    end

    def user_admin?
    	unless current_user.access_code == 111
    		flash[:error] = "You can't do this"
    		redirect_to root_path
    	end
    end

    # отправка на root_path вызывает рекурсию
    def user_present?
    	redirect_to plugins_path if !current_user
    end
end