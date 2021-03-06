class TheatersController < ApplicationController
  before_action :require_login

  def index
    @theaters = Theater.all
  end

  def new
    @theater = Theater.new
  end

  def create
    @theater = Theater.new(theater_params)

    if @theater.save
      redirect_to theaters_path, notice: 'Theater added'
    else
      render :new
    end
  end

  def edit
    @theater = Theater.find(params[:id])
  end

  def update
    @theater = Theater.find(params[:id])

    if @theater.update(theater_params)
      redirect_to theaters_path, notice: 'Theater updated'
    else
      render :edit
    end
  end

  private

  def theater_params
    params.require(:theater).permit(:name, :imdb_name, :address, :city, :state, :zip, :phone, :website)
  end
end
