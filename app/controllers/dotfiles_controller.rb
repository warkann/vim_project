class DotfilesController < ApplicationController
  before_action :set_dotfile, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]

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
    if @dotfile.update(dotfile_params)
      redirect_to @dotfile
    else
      render :edit
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

    def set_dotfile
      @dotfile = Dotfile.friendly.find(params[:id])
    end

    def dotfile_params
      params.require(:dotfile).permit(:title, :body, :slug)
    end

    # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      check_permissions(@dotfile)
    end
end
