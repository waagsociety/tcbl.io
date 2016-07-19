class Machine < Thing
  include Authority::Abilities
  def to_param
    "#{id}-#{brand}-#{name}".parameterize
  end
end
