class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  def new
    render
  end

  def create
    if params[:username] == Rails.application.credentials.admin_user && params[:password] == Rails.application.credentials.admin_password
      session[:admin] = true
      redirect_to theaters_path
    else
      render :new
    end
  end

  def destroy
    reset_session
    redirect_to root_path
  end
end
