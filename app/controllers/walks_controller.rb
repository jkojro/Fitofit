class WalksController < ApplicationController

  def show
    @walk = Walk.find(params[:id])
    @this_week_walks_distance = Walk.group_by_week(:created_at, last: 1).sum(:distance).values.first
  end

  def new
    @walk = Walk.new
  end

  def create
    @walk = Walk.new(walk_params)
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
