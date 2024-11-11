module SubscriptionsHelper
  def subscribe?(question, user)
    subscription = Subscription.where(question: question, user: user)

    subscription.present?
  end
end
