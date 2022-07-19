class KudoPolicy < ApplicationPolicy
  def update?
    true if Time.current <= record.created_at.advance(minutes: 5)
  end

  def destroy?
    true if Time.current <= record.created_at.advance(minutes: 5)
  end
end
