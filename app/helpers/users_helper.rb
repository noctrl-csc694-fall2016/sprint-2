module UsersHelper
  
  def is_admin?
    current_user && current_user.permission_level == 1
  end
  
  def is_super?
    current_user.permission_level == 1 && current_user.id == 1
  end
  
  def user_exists?
      User.find_by_id(params[:id])
  end
  
  def user_exists
    if !user_exists?
      flash[:danger] = "User does not exist"
      redirect_to home_path
    end
  end
  
  def is_super
    if !is_super?
      flash[:danger] = "You do not have permission to view this page."
      redirect_to home_path
    end
  end
  
  #returns the public/visible id for the user
  def get_user_id(user)
    if user.id < 10
      return "USR0" + user.id.to_s
    else
      return "USR" + user.id.to_s
    end
  end
  
  #returns a string indicating user type
  def get_user_type(user)
    userExists = User.find_by_id(user.id)
    if userExists && user.permission_level == 1
      return "Admin"
    elsif userExists && user.permission_level == 0
      return "Standard"
    end
  end
  
  #returns a datetime indicating the last time the user logged in
  def get_last_login(user)
    userExists = User.find_by_id(user.id)
    if userExists
      return userExists['last_login']
    end
  end
  
end
