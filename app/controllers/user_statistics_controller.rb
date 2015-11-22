class UserStatisticsController < ApplicationController

  before_action :authenticate_user!
  before_action :check_permission

  def index
    @user_statistics = UserStatistic.joins(:user)
  end

  private

  def check_permission
    current_user.admin? || raise(ActionController::RoutingError.new('Not Found'))
  end

end