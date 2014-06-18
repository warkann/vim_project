class HacksController < ApplicationController
  before_action :set_hack, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def index
# Этот метод из application_controller.rb, предназначен для отображения количества используемых
# в данной модели тэгов, в качестве аргумента передается название модели с заглавной буквы
    work_with_tags(:Hack)

    if params[:tag]
      @hacks = Hack.tagged_with(params[:tag])
    else
      @hacks = Hack.all
    end
  end

  def show
  end

  def new
    @hack = Hack.new
  end

  def edit
  end

  def create
    @hack = current_user.hacks.new(hack_params)

      if @hack.save
        flash[:success] = "Hack was successfully created"
        redirect_to @hack
      else
        flash[:error] = "Hack was not created"
        render :new
      end
  end

  def update
    respond_to do |format|
      if @hack.update(hack_params)
        format.html { redirect_to @hack, notice: 'Hack was successfully updated.' }
        format.json { render :show, status: :ok, location: @hack }
      else
        format.html { render :edit }
        format.json { render json: @hack.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @hack.destroy
    respond_to do |format|
      format.html { redirect_to hacks_url, notice: 'Hack was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hack
      @hack = Hack.friendly.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_params
      params.require(:hack).permit(:title, :body, :tag_list, :tag, :slug)
    end

    def correct_user
      unless current_user.admin? || current_user.id == @hack.user_id
        flash[:error] = "Access denied"
        redirect_to root_path
      end
    end

end
