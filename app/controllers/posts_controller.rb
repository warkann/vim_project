class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]

	def index
    # Этот метод из application_controller.rb, предназначен для отображения количества используемых
    # в данной модели тэгов, в качестве аргумента передается название модели с заглавной буквы
    work_with_tags(:Post)
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    else
		  @posts = Post.all
    end
	end

	def show
	end

	def new
		@post = Post.new
	end

	def create
    @post = current_user.posts.new(post_params)
    if @post.save
      flash[:success] = "Post was successfully created"
      redirect_to @post
    else
      flash[:error] = "Post was not created"
      render :new
    end
	end

	def edit
	end

	def update
    if @post.update(post_params)
      redirect_to @post
    else
      render :edit
    end
	end

	def destroy
    @post.destroy
    redirect_to posts_path
	end

  private

    def set_post
      @post = Post.friendly.find(params[:id])
    end

    def post_params
      params.require(:post).permit(current_user.id, :title, :body, :tag_list, :tag, :post_img, :post_img_cache, :slug)
    end

    # даем разрешение на редактирование и удаление записей только админам, модераторам и создателям этой записи
    def give_access_to_edit_record
      check_permissions(@post)
    end
  end