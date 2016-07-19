# event mag worden aangemaakt door iedereen.
# alleen de eigenaar en/of superadmin mag 'm aanpassen en/of verwijderen
class EventAuthorizer < ApplicationAuthorizer

  def updatable_by?(user)
    user.has_role?(:superadmin) or user.has_role?(:admin, resource) or user.is_creator? resource
  end

  def readable_by?(user)
	  true
  end

  def self.creatable_by?(user)
    true
  end

  def self.deletable_by?(user)
    user.has_role?(:superadmin) or user.has_role?(:admin, resource) or user.is_creator? resource
  end
 
end
