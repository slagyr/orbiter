# Orbital Simulation
# This program combines two simple Baubles (components) to make an
# orbit simulation.  The first Bauble is 'cellular_automaton' which
# manages a swing window and enables very simple drawing.  The second
# Bauble is "Physics" which provides the simulation of objects that have
# mass and gravity.
#
# The simulation creates a star surrounded by a random number of
# planetesimals that have a small and random velocity tangent to
# the star.  This simulates a slowly rotating cloud with the star
# at the center.
#
# The screen clears at ever increasing intervals in order to clean up the
# old traces and allow you to see how the system evolves.  Some of the events
# are quite striking as planetesimals collide and interact.
#

require 'physics/Physics'

class OrbitWorld
  def random(range)
    delta = range.last - range.first
    range.first + rand*delta
  end

  def initialize(xcells, ycells)
    @clear_time = Time.new
    @clear_delay = 30
    @xcells = xcells
    @ycells = ycells
    @origin = Physics::Point.new(xcells/2, ycells/2)
    @center = Physics::Vector.new(0,0)
    @magnification = 0.7
    @p = Physics.new
    add_sun
    add_planetesimals
  end

  def add_sun
    sun = @p.add_object("sun")
    sun.mass = 300
    sun.position = @origin.dup
  end

  def add_planetesimals
    (1..random(10..200)).each do |name|
      add_planetesimal(name)
    end
  end

  def add_planetesimal(name)
    o = @p.add_object name
    o.position = select_position()
    o.velocity = select_velocity_based_on(o.position)
    o.mass = random(0.1..1.0)
  end

  def select_position()
    Physics::Point.new(center_half(@xcells), center_half(@ycells))
  end

  def center_half(dimension)
    upper = dimension*0.75
    lower = dimension*0.25
    random(lower..upper)
  end

  def select_velocity_based_on(position)
    orbital_tangent(position) * 17/Math.sqrt(@origin.distance(position))
  end

  def orbital_tangent(position)
    slope = @origin.slope(position)
    if (slope == nil)
      Physics::Velocity.new(1, 0)
    elsif (slope == 0)
      Physics::Velocity.new(0, 1)
    else
      slope = -1.0/slope
      v = Physics::Velocity.new(1, slope)
      v /= v.magnitude #sets magnitude == 1
      v *= -1 if position.y > @origin.y
      v
    end
  end

  def step(screen)
    sporadically_clean_up(screen)
    draw_objects(screen)
    @p.tic 1
  end

  def draw_objects(screen)
    center_offset = find_center
    @p.objects.each do |object|
      draw(screen, object.position - center_offset, object.mass)
    end
  end

  def find_center
    @center
  end

  def draw(screen, point, weight)
    offsetFactor = (@magnification-1.0)/@magnification
    x = point.x/@magnification + offsetFactor*@origin.x
    y = point.y/@magnification + offsetFactor*@origin.y
    screen.draw_cell(x, y, weight, @magnification)
  end

  def sporadically_clean_up(screen)
    if (Time.new - @clear_time) > @clear_delay
#      screen.clear_screen
#      if @magnification < 20
#        @clear_time = Time.new
#        @magnification *= 1.25
#      else
        @clear_delay = 120
      end
      delete_objects_too_far_from_sun
#    end
  end

  def delete_objects_too_far_from_sun
    to_delete = []
    sun = @p.find("sun")
    @p.objects.each do |object|
      if sun.distance(object) > 10000
        to_delete << object.name
      end
    end
    to_delete.each do |name|
      @p.delete(name)
    end
  end

  def zoom_in
    sun = @p.find("sun")
    @center = sun.position - @origin
    @magnification *= 0.75;
  end

  def zoom_out
    sun = @p.find("sun")
    @center = sun.position - @origin
    @magnification *= 1.25;
  end
end