class UsersController < ApplicationController
  before_action :authenticate_user!
  #after_action :verify_authorized

  def show
    @user = User.find(params[:id])
    #authorize @user
    if @user != current_user
      redirect_to root_url
    end
  end

end
