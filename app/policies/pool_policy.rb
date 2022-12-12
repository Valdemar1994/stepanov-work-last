# frozen_string_literal: true

class PoolPolicy
  attr_reader :user, :record
  
  def initialize(user, record)
    @user = user
    @record = record
  end
  
  def index?
    current_user.has_role? :manager
  end
  
  def show?
    false
  end
  
  def create?
    user.has_role? :manager
  end
  
  def new?
    user.has_role? :manager
  end
  
  def update?
    false
  end
  
  def edit?
    update?
  end
  
  def destroy?
    user.has_role? :manager
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.has_role? :manager
        scope.all
      else
        scope.none
      end
    end

  end
end
