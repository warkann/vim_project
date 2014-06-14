class ColorschemasController < ApplicationController
  before_action :set_colorschema, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  
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
    # Use callbacks to share common setup or constraints between actions.
    def set_colorschema
      @colorschema = Colorschema.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def colorschema_params
      params.require(:colorschema).permit(:title, :body, :colorschema_img, :coloschma_img_cache, :slug)
    end

    def correct_user
      unless current_user.admin? || current_user.id == @colorschema.user_id
        flash[:error] = "Access denied"
        redirect_to root_path
      end
    end

end
