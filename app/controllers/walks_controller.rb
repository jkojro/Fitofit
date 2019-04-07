class WalksController < ApplicationController
  before_action :authenticate_user!

  def show
    @walk = Walk.find(params[:id])
    @this_week_walks_distance = current_user.walks.group_by_week(:created_at, last: 1).sum(:distance).values.first
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
