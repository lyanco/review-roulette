class EntryPolicy
  attr_reader :user, :entry

  def initialize(user, entry)
    @user = user
    @entry = entry
  end

  def index?
    true
  end

  def show?
    #scope.where(id: entry.id).exists?
    true
  end

  def create?
    @entry.user_id == user.id
  end

  def new?
    create?
  end

  def update?
    @entry.user_id == user.id
  end

  def edit?
    update?
  end

  def destroy?
    @entry.user_id == user.id
  end

  def scope
    Pundit.policy_scope!(user, entry.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.where(user_id: @user.id)
    end
  end
end
