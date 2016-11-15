module ReportsHelper
  include UsersHelper
  
  # Retrieve the current user object
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
end
