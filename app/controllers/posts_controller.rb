class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]


	def index
    if params[:tag]
      @posts = Post.tagged_with(params[:tag])
    else
		  @posts = Post.all
    end
  # эта часть для отображения списка ТОП-10 тегов
    @tags = Tag.order('taggings_count DESC')
    @tags.first(10)
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

	# Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.friendly.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(current_user.id, :title, :body, :tag_list, :tag, :post_img, :post_img_cache, :slug)
  end

  def correct_user
    unless current_user.admin? || current_user.id == @post.user_id
      flash[:error] = "Access denied"
      redirect_to root_path
    end
  end
end
