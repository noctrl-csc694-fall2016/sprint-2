class SessionsController < ApplicationController
  # Logging out is only allowed if the user is actually logged in
  before_action :logged_in, only: [:destroy]
  
  # If the user is already logged in, they should be routed to the homepage.
  #  Otherwise, render the login (new) screen
  def new
    #if logged_in?
    #  redirect_to home_path
    #end
  end

  # Create will log the user in, or display a message if the login attempt
  #  is unsuccessful.
  def create
    # Find the user by their user ID
    user = User.where(:email => params[:session][:email].downcase).first
    
    # If the user exists and the password is valid, send them to the home page
    if user && user.authenticate(params[:session][:password])
      # Store the user_id in the session
      log_in user
      flash[:success] = "Welcome #{user.username}"
      redirect_to home_path
    else
      # Otherwise, keep them on the login page.
      flash.now[:danger] = 'Invalid username or password'
      render 'new'
    end
  end

  # This is the log-out function. Will log the user out of the session,
  #  and send them to the homepage.
  def destroy
    # Log the user out of the session
    log_out
    # Display the following message when the user has been redirected
    flash[:success] = "You have successfully been logged out."
    # Redirect the user to the login page, thus completing the logout process
    redirect_to '/login'
  end
end
