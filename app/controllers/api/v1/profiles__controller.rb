class Api::V1::ProfilesController < Api::V1::BaseController
  def me
    authorize! :show, User
    render json: current_user
  end

  def index
    authorize! :index, User
    @users = User.all.reject { |user| user == current_user }
    render json: @users
  end
end
