class SessionsController < ApplicationController
  #----------------------------------#
  # GiftGarden Sessions Controller
  # original written by: Pat M, Nov 7 2016
  # major contributions by:
  #
  #----------------------------------#
  
  # Logging out is only allowed if the user is actually logged in
  before_action :logged_in, only: [:destroy]

  def new
  end

  #logs the user in, or displays a message if the login attempt fails
  #stores the user id into the session object
  def create
    user = User.where(:username => params[:session][:username].downcase).first
    
    if user && user.authenticate(params[:session][:password])
      log_in user
      user['last_login'] = Time.now.to_datetime
      user.save
      flash[:success] = "Welcome back #{user.username}!"
      redirect_to home_path
    else
      # Otherwise, keep them on the login page.
      flash.now[:danger] = 'Invalid username or password'
      render 'new'
    end
  end

  #log-out function. Logs user out of the session, sends them to the login page.
  def destroy
    log_out
    #flash[:success] = "You have successfully been logged out."
    redirect_to '/login'
  end
end
