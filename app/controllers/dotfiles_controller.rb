class DotfilesController < ApplicationController
  before_action :set_dotfile, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
    @dotfiles = Dotfile.all
  end

  def show
  end

  def new
    @dotfile = Dotfile.new
  end

  def edit
  end

  def create
    @dotfile = current_user.dotfiles.new(dotfile_params)

      if @dotfile.save
        flash[:success] = "Dotfile was successfully created"
        redirect_to @dotfile
      else
        flash[:error] = "Dotfile was not created"
        render :new
      end
  end

  def update
    respond_to do |format|
      if @dotfile.update(dotfile_params)
        format.html { redirect_to @dotfile, notice: 'Dotfile was successfully updated.' }
        format.json { render :show, status: :ok, location: @dotfile }
      else
        format.html { render :edit }
        format.json { render json: @dotfile.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dotfile.destroy
    respond_to do |format|
      format.html { redirect_to dotfiles_url, notice: 'Dotfile was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_dotfile
      @dotfile = Dotfile.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def dotfile_params
      params.require(:dotfile).permit(:title, :body, :slug)
    end

    def correct_user
      unless current_user.admin? || current_user.id == @dotfile.user_id
        flash[:error] = "Access denied"
        redirect_to root_path
      end
    end

end
