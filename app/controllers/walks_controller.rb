class WalksController < ApplicationController
  before_action :authenticate_user!

  def index
    @actual_month_walks = PresentMonthWalksQuery.new.call(current_user)
  end

  def show
    @walk = Walk.find(params[:id])
    @this_week_walks_distance = PresentWeekWalksDistance.new.call(current_user)
  end

  def new
    @walk = current_user.walks.build
  end

  def create
    @walk = current_user.walks.build(walk_params)
    @walk = BuildWalkWithDistanceService.new(@walk).call

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
