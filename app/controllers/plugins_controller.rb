class PluginsController < ApplicationController
  before_action :set_plugin, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]
  before_action :give_access_to_add_record, except: [:index, :show]


  def index
# Этот метод из application_controller.rb, предназначен для отображения количества используемых
# в данной модели тэгов, в качестве аргумента передается название модели с заглавной буквы
    work_with_tags(:Plugin)

    if params[:tag]
      @plugins = Plugin.tagged_with(params[:tag])
    else
      @plugins = Plugin.all
    end
  end

  def show
  end

  def new
    @plugin = Plugin.new
  end

  def edit
  end

  def create
    @plugin = current_user.plugins.new(plugin_params)

      if @plugin.save
        flash[:success] = "Plugin was successfully created"
        redirect_to @plugin
      else
        flash[:error] = "Plugin was not created"
        render :new
      end
  end

  def update
    respond_to do |format|
      if @plugin.update(plugin_params)
        format.html { redirect_to @plugin, notice: 'Plugin was successfully updated.' }
        format.json { render :show, status: :ok, location: @plugin }
      else
        format.html { render :edit }
        format.json { render json: @plugin.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @plugin.destroy
    respond_to do |format|
      format.html { redirect_to plugins_url, notice: 'Plugin was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_plugin
      @plugin = Plugin.friendly.find(params[:id])
    end

    def plugin_params
      params.require(:plugin).permit(current_user.id, :title, :description, :link, :tag_list, :tag, :slug)
    end


# даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      unless current_user.access_code == 111 || 
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