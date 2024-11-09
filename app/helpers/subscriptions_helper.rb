module SubscriptionsHelper
  def subscribe?(question, user)
    subscription = Subscription.where(question: question, user: user)
    if subscription.empty?
      false
    else
      true
    end
  end
end
