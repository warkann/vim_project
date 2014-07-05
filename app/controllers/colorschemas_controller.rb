class ColorschemasController < ApplicationController
  before_action :set_colorschema, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]

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
    if @colorschema.update(colorschema_params)
      redirect_to @colorschema
    else
      render :edit
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
      check_permissions(@colorschema)
    end
end
