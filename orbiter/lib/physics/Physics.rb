# A very simple physics calculator for gravity and inelastic collisions.
# The scheme here is not sophisticated.  It simply calculates and applies
# forces from one time period to the next.

require 'physics/physics_helper.rb'

class Physics
  def initialize
    @objects = {}
  end

  def add_object(name)
    o = Physics::Object.new(name)
    @objects[name] = o
    o
  end

  def [](name)
    @objects[name]
  end

  def find(name)
    objects.each do |object|
      return object if object.name.to_s.include?(name)
    end
    nil
  end

  def objects
    @objects.values
  end

  def tic(n)
    n.times {
      calculate_forces
      apply_forces
      move_objects
      detect_collisions
    }
  end

  def move_objects
    objects.each do |object|
      object.move
    end
  end

  def calculate_forces
    objects.each do |object|
      calculate_forces_on object
    end
  end

  def calculate_forces_on(primary)
    primary.clear_force
    objects.each do |object|
      if (primary != object)
        primary.add_force calculate_force_between(primary, object)
      end
    end
  end

  def calculate_force_between(primary, object)
    d = primary.distance object
    if (d <= 0)
      Force.new(0, 0)
    else
      f = (primary.mass * object.mass) / (d*d)      
      ds = primary.position - object.position
      ds * (-f/d)
    end
  end

  def apply_forces
    objects.each do |object|
      force = object.force
      mass = object.mass
      object.velocity += force / mass if mass > 0
    end
  end

  def detect_collisions
    @collisions = []
    objects.each do |object|
      detect_collision_with object if !@collisions.include?(object)
    end
  end

  def detect_collision_with(primary)
    objects.each do |object|
      if (object != primary)
        detect_collision_between(primary, object) if !@collisions.include?(object)
      end
    end
  end

  def detect_collision_between(primary, object)
    if primary.distance(object) < 3
      delete_colliders(primary, object)
      inelastic_collision(primary, object)
    end
  end

  def delete_colliders(primary, object)
    @collisions << object
    @collisions << primary
    @objects.delete primary.name
    @objects.delete object.name
  end

  def inelastic_collision(primary, object)
    o = add_object(name_collision(primary, object))
    o.mass = primary.mass + object.mass
    m_primary = primary.velocity * primary.mass
    m_object = object.velocity * object.mass
    o.velocity = (m_object + m_primary)/o.mass
    o.position = (object.position + primary.position)/2
  end

  def name_collision(primary, object)
    names = [primary.name.to_s, object.name.to_s].sort
    name = names[0]+"-"+names[1]
  end

  def delete(name)
    @objects.delete name
  end
end