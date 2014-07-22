class HacksController < ApplicationController
  before_action :set_hack, only: [:show, :edit, :update, :destroy, :vote]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]

  def index
    # Этот метод из application_controller.rb, предназначен для отображения количества используемых
    # в данной модели тэгов, в качестве аргумента передается название модели с заглавной буквы
    work_with_tags(:Hack)
    if params[:tag]
      @hacks = Hack.tagged_with(params[:tag])
    else
      @hacks = Hack.order('popularity DESC')
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
    if @hack.update(hack_params)
      redirect_to @hack
    else
      render :edit
    end
  end

  def destroy
    @hack.destroy
    redirect_to hacks_path
  end

  # метод, отвечающий за рейтинг хака
  def vote
    Hack.vote(@hack, current_user)
    redirect_to hacks_path
  end

  private

    def set_hack
      @hack = Hack.friendly.find(params[:id])
    end

    def hack_params
      params.require(:hack).permit(:title, :body, :tag_list, :tag, :slug, :popularity)
    end

    # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      check_permissions(@hack)
    end
end
