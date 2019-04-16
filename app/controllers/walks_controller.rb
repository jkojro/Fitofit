class WalksController < ApplicationController
  before_action :authenticate_user!

  def index
    @actual_month_walks = current_user.walks.actual_month_walks
  end

  def show
    @walk = Walk.find(params[:id])
    @this_week_walks_distance = current_user.walks.this_week_walk_distance
  end

  def new
    @walk = current_user.walks.build
  end

  def create
    @walk = current_user.walks.build(walk_params)
    if @walk.save
      redirect_to @walk
    else
      render :new
    end
  end

  private

  def walk_params
    params.require(:walk).permit(:start_location, :end_location, :distance)
  end
end
