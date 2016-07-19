#iedereen mag machines aanmaken en editen, en ook aanpassen, zodat je je eigen machine aan het lab kunt hangen.
class ThingAuthorizer < ApplicationAuthorizer

  def self.creatable_by?(user)
	true
  end

  def self.updatable_by?(user)
    # user.has_role?(:superadmin) #or user.is_creator? resource
	true
  end

  def self.readable_by?(user)
    true
  end

  def self.deletable_by?(user)
    user.has_role?(:superadmin) #or user.is_creator? resource
  end

end
