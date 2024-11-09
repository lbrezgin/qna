class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    @subscription = Subscription.new
    @subscription.user = current_user
    @subscription.question = Question.find(params[:question_id])

    @subscription.save
  end

  def destroy
    @subscription = Subscription.find(params[:id])
    @subscription.destroy
  end
end
