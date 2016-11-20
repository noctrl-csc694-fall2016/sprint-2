class UsersController < ApplicationController
  #users must be logged into access any of this controller's methods/views
  before_action :logged_in
  before_action :user_exists, except: [:index, :new, :create]
  before_action :is_admin, except: [:update, :edit]
  
  #Diplays all users, each user in a row
  def index
     #display superadmin only if superadmin is logged in
    if is_super? 
     @users = User.all.order("(id)")
    else
     @users = User.where("id >= 2", true).order("(id)")
    end
    
    #show users sorted by user id
    @users.sort { |a,b| a.id <=> b.id }
    
    #paginate selected users list
    @users = @users.paginate(page: params[:page], per_page: 10)
    
  end
  
  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    
    #tell user superadmin does not exist to hide his superduper secret existence
    if !is_super? && @user.id == 1
      flash[:danger] = "User does not exist"
      redirect_to home_path
    end
  end

  #Called when a user selects "Settings".  If the user is admin, they are
  #redirected to 'show', just as if they cliked themself on the user list.
  def edit
    @user = User.find(params[:id])
    if @user.permission_level == 1
      redirect_to action: "show"
    end
  end

  # creates new user with permitted user params defined below in private section
  # or renders for again with error messages
  def create
    @user = User.new(new_user_params)
    if @user.save
      flash[:success] = "User added successfully!"
      redirect_to '/users'
    else
      render 'new'
    end
  end

  #The Update method has 5 cases
  #super admins updating an account
  #Admins updating themselves (admins cannot delete themselves)
  #admins updating other accounts (cannot update superadmin)
  #Entry or standard accounts updating themselves
  #Entry or standard updating someone they do not have permission to update
  
  #Admins can delete other accounts, update passwords and permission levels
  #
  def update
    @user = User.find(params[:id])
    
    if is_super? 
      #confirm password then update users info
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "User " + @user.username + " has been updated."
        redirect_to user_list_path
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
    #admin edits other user  
    elsif is_admin? && current_user.username != @user.username
      #confirm password then update users info
      if current_user.authenticate(params[:user][:current_password]) && 
        @user.update_attributes(admin_params)
        flash[:success] = "User " + @user.username + " has been updated."
        redirect_to user_list_path
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
    #admin edits self
    elsif is_admin? && current_user.username == @user.username
      #confirm password then update user's info
      if current_user.authenticate(params[:user][:current_password]) && @user.update_attributes(admin_params)
        flash[:success] = "Your account has been updated."
        redirect_to action: "show"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
    #user edits self
    elsif current_user.username == @user.username
      if(@user.update_attributes(user_params))
        flash[:success] = "Your account has been updated."
        redirect_to home_path
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "show"
      end
    #user edits other
    else
      flash[:danger] = "You do not have permission to update that user"
      redirect_to home_path
    end
  end
  
  #destroy is an action that admins can use to delete accounts
  #but not themselves. Super admin is hidden from all others.
  def destroy
    #check user is not deleting self
    if User.find(params[:id]).username != current_user.username
      if User.find(params[:id]) == 1
        flash[:danger] = "User does not exist"
        redirect_to home_path
      else  
        name = User.find(params[:id]).username
        User.find(params[:id]).destroy
        flash[:success] = "Successfully deleted user " + name.to_s
        redirect_to users_url
      end
    else
      flash[:danger] = "You cannot delete yourself"
      redirect_to action: "show"
    end
  end
  
  
  #password and password confirmation are BCrypt defaults.  They must be called
  #by these names for BCrypt to recognize them. They aren't part of user model.
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def super_params
      params.require(:user).permit(:password, :password_confirmation,  :permission_level)
    end
    
    def new_user_params
      params.required(:user).permit(:username, :email, :password, :password_confirmation, :permission_level)
    end
    
    def admin_params
      params.require(:user).permit(:permission_level, :password, :password_confirmation)
    end
    
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end
    
    # Before filters

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to root_url
      end
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end
end
