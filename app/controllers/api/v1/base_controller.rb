class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  protected

  def current_ability
    @ability ||= Ability.new(current_user)
  end

  private

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
