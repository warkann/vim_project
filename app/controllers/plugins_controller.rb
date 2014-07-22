class PluginsController < ApplicationController
  before_action :set_plugin, only: [:show, :edit, :update, :destroy, :vote]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]

  def index
    # Этот метод из application_controller.rb, предназначен для отображения количества используемых
    # в данной модели тэгов, в качестве аргумента передается название модели с заглавной буквы
    work_with_tags(:Plugin)
    if params[:tag]
      @plugins = Plugin.tagged_with(params[:tag])
    else
      @plugins = Plugin.order('popularity DESC')
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
    if @plugin.update(plugin_params)
      redirect_to @plugin
    else
      render :edit
    end
  end

  def destroy
    @plugin.destroy
    redirect_to plugins_path
  end

  # метод, отвечающий за рейтинг плагина
  def vote
    Plugin.vote(@plugin, current_user)
    redirect_to plugins_path
  end

  private

    def set_plugin
      @plugin = Plugin.friendly.find(params[:id])
    end

    def plugin_params
      params.require(:plugin).permit(:title, :description, :link, :tag_list, :tag, :slug, :popularity)
    end

    def give_access_to_edit_record
      check_permissions(@plugin)
    end
  end