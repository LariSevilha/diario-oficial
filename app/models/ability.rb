# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user

    # super user
    if user.super_user?
      can :manage, :all
    # admin
    elsif user.admin_user?
      can :create, User
      can :manage, User, entitys: { id: user.entity_ids }
      can :read, User, entitys: { id: user.entity_ids }

      cannot :create, User, super_user: true

      can :manage, Office
      can :manage, TypeEntity

      can :create, Entity
      can :manage, Entity, id: user.entity_ids
      can :read, Entity, id: user.entity_ids

      can :manage, DiaryCategory
      can :manage, DiarySubCategory
      can :manage, BranchGovernment

      can :create, OfficialDiary
      can :manage, OfficialDiary, entity: { id: user.entity_ids }
      can :read, OfficialDiary, entity: { id: user.entity_ids }

    # commom
    elsif user.common_user?
      can :manage, User, id: user.id

      if user.register?
        can :create, OfficialDiary
        can :manage, OfficialDiary, entity: { id: user.entity_ids }
      end

      can :read, OfficialDiary, entity: { id: user.entity_ids } if user.read?

      if user.publish?
        #  add actions to publish
      end
    end
  end
end
