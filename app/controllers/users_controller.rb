class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index]
  before_filter :correct_user, only: [:edit, :update]
  
  def new
    @user = User.new    
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = 'user created'
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    # correct_user method does this line for you:
    # @user = User.find(params[:id])
  end
  
  def update
    # correct_user method does this line for you:
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = 'user updated'
      sign_in @user
      redirect_to users_path
    else
      render 'edit'
    end
  end

  def show
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'user deleted'
    redirect_to users_path
  end
  
  # def confirm_email
  #   # PARAMS[:hash] => confirmation_hash for an email address
  #   user = User.find_by(confirmation_hash: params[:hash])
  #   if user
  #     user.confirmed = true
  #     user.save
  #     sign_in(user)
  #     redirect_to user
  #   else
  #     flash[:error] = 'could not confirm this email'
  #     redirect_to root_path
  #   end
  # end
  
  private
  
  def user_params
    params
      .require(:user)
      .permit(:first, :last, :email, :password, :password_confirmation, :karma)
  end
  
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end
  
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end  

end
