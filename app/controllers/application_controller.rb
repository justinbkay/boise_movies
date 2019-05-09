class ApplicationController < ActionController::Base
  def require_login
    session[:admin].blank? && redirect_to(root_path)
  end
end
