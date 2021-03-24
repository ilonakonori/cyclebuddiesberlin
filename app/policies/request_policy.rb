class RequestPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def show?
    record.recipient_id == user.id || record.user_id == user.id
  end

  def create?
    true
  end

  def destroy?
    record.recipient_id == user.id && Conversation.find_by(request_id: record.id).nil?
  end
end
