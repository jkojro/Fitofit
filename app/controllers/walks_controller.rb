class WalksController < ApplicationController
  before_action :authenticate_user!

  def index
    relation = current_user.walks
    @actual_month_walks = PresentMonthWalksQuery.new.call(relation)
  end

  def show
    @walk = Walk.find(params[:id])
    relation = current_user.walks
    @this_week_walks_distance = PresentWeekWalksDistance.new.call(relation)
  end

  def new
    @walk = current_user.walks.build
  end

  def create
    @walk = current_user.walks.build(walk_params)
    if CountWalkDistanceService.new.call(walk: @walk).success?
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
