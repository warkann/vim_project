class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :give_access_to_edit_record, only: [:edit, :update, :destroy]
  before_action :give_access_to_add_record, except: [:index, :show]
 
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
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end	
	end

	def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
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
      unless current_user == nil ||
              current_user.access_code == 111 || 
              current_user.access_code == 110 || 
              current_user.id == @plugin.user_id
        flash[:error] = "You can't do it"
        redirect_to plugins_path
      end
    end

    # даем разрешение на создание новых записей всем зарегестрированным пользователям
    def give_access_to_add_record
      redirect_to plugins_path if current_user.nil?
    end 
  end