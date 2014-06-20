class ColorschemasController < ApplicationController
  before_action :set_colorschema, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]
  before_action :give_access_to_add_record, except: [:index, :show]
  
  def index
    @colorschemas = Colorschema.all
  end

  def show
  end

  def new
    @colorschema = Colorschema.new
  end

  def edit
  end

  def create
    @colorschema = current_user.colorschemas.new(colorschema_params)

      if @colorschema.save
        flash[:success] = "Color schema was successfully created"
        redirect_to @colorschema
      else
        flash[:error] = "Color schema was not created"
        render :new
      end
  end

  def update
    respond_to do |format|
      if @colorschema.update(colorschema_params)
        format.html { redirect_to @colorschema, notice: 'Colorschema was successfully updated.' }
        format.json { render :show, status: :ok, location: @colorschema }
      else
        format.html { render :edit }
        format.json { render json: @colorschema.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @colorschema.destroy
    respond_to do |format|
      format.html { redirect_to colorschemas_url, notice: 'Colorschema was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def set_colorschema
      @colorschema = Colorschema.friendly.find(params[:id])
    end

    def colorschema_params
      params.require(:colorschema).permit(:title, :body, :colorschema_img, :coloschma_img_cache, :slug)
    end

    # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      unless current_user == nil ||
              current_user.access_code == 111 || 
              current_user.access_code == 110 || 
              current_user.id == @colorschema.user_id
        flash[:error] = "You can't do it"
        redirect_to plugins_path
      end
    end

    # даем разрешение на создание новых записей всем зарегестрированным пользователям
    def give_access_to_add_record
      redirect_to plugins_path if current_user.nil?
    end 
end
