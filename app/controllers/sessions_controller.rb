class SessionsController < ApplicationController
  before_action :require_login, only: :destroy
  def new
    render
  end

  def create
  end

  def destroy

  end
end
