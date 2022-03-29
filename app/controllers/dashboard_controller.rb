class DashboardController < ApplicationController
  def show
    @pagy, @orders = pagy(Order.sort_by_params(params[:sort], sort_direction))
  end
end
