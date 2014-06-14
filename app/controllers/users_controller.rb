class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]	

	def index
	end

	def edit
		@user.update_attributes(:admin => 'true')
		redirect_to @user
	end
	
	def show
	end

	def destroy
		if @user != current_user
			@user.destroy
			redirect_to root_path
		else
			flash[:error] = "Not possible"
		end
	end

private

	# Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.friendly.find(params[:id])
  end

end
