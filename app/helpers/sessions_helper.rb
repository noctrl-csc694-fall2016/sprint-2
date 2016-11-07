module SessionsHelper
  include UsersHelper
  
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
  end
  
  # Retrieve the current user object
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  # A boolean function for determining if the user is logged in
  def logged_in?
    # If the current_user function returns nil, then it means the user
    #  is not logged in.
    !current_user.nil?
  end
  
  def is_admin
    if !is_admin?
      flash[:danger] = "You are not an admin"
      redirect_to home_path
    end
  end
  
  def admin_or_standard
    if !is_admin? && !is_standard?
      flash[:danger] = "You do not have permission to view this page"
      redirect_to home_path
    end
  end
  
  # Redirects the user to the login page if they are not logged in.
  #  This function is intended to be used as a before_action callback.
  def logged_in
    if !logged_in?
      flash[:danger] = "You are not logged in"
      redirect_to login_url
    end
  end
  
  # This will remove the user_id from the session. Redirecting to the
  #  home (login) page is left as a task for the calling code.
  def log_out
    # Delete the user_id token from the session
    session.delete(:user_id)
    # Set the current user to nil, so that nothing else operates on the
    #  (now mistaken) assumption that the user is still logged in.
    @current_user = nil
  end
  
  def should_view_user(uid)
    if current_user.id != uid && !is_admin?
      flash[:danger] = "You are not authorized to view this page"
      redirect_to home_path
    end
  end
end
