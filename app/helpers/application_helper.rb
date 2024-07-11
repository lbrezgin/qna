module ApplicationHelper
  def author?(user, entity)
    user.id == entity.user_id
  end
end
