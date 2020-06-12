class UsersController < ApplicationController
  def index
    if params[:query].present?
      @users = User.user_search(params[:query])
    else
      @users = User.all
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit

  end

  def update

  end

  def followers
    @users = current_user.followers
  end

  def follows
    @users = current_user.leaders
  end

  private

  def user_params

  end
end
