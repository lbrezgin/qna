# frozen_string_literal: true
class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :create, [Question, Answer, Comment, Link, Reward, ActiveStorage::Attachment]
    can :update, [Question, Answer, Comment], user: user
    can :destroy, [Question, Answer, Comment], user: user

    can :mark_as_best, Answer do |answer|
      answer.question.user == user
    end

    can [:like, :dislike], [Question, Answer] do |answer|
      answer.user != user
    end

    can [:destroy], Link do |link|
      link.linkable.user == user
    end

    can :destroy, ActiveStorage::Attachment do |file|
      file.record_type.constantize.where(id: file.record_id)[0].user == user
    end
  end
end
