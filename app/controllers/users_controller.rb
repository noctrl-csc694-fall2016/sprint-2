class UsersController < ApplicationController
  def index
  end

  def show
  end

  def edit
  end

  def create
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
    
    #user edits self
    if current_user.username == @user.username
    
      if(@user.update_attributes(user_params))
        flash[:success] = "Your account has been updated."
        redirect_to action: "edit"
      else
        flash[:danger] = "Passwords invalid or do not match"
        redirect_to action: "edit"
      end
      
    #user edits other
    else
      flash[:danger] = "You do not have permission to update that user"
      redirect_to home_path
      
    end
  end
  
  
  #password and password confirmation are BCrypt defaults.  They must be called
  #by these names for BCrypt to recognize them
  #They are not part of the user model
  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def super_params
      params.require(:user).permit(:password, :password_confirmation,  :permission_level)
    end
    
    def new_user_params
      params.require(:user).permit(:username, :email, :permission_level, :password, :password_confirmation)
    end
    
    def admin_params
      params.require(:user).permit(:permission_level, :password, :password_confirmation)
    end
    
    def user_params
        params.require(:user).permit(:password, :password_confirmation)
    end
end
