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

require 'rubygems'
require 'bauble'
Bauble.use('../../cellular_automaton')
Bauble.use('../../Physics')

class OrbitWorld
  def random(range)
    delta = range.last - range.first
    range.first + rand*delta
  end

  def initialize(xcells, ycells)
    @step = 0
    @clear_limit = 500
    @xcells = xcells
    @ycells = ycells
    @origin = Physics::Point.new(xcells/2, ycells/2)
    @p = Physics.new
    add_sun
    add_planetesimals
  end

  def add_sun
    sun = @p.add_object("sun")
    sun.mass = random(100..300)
    sun.position = @origin.dup
  end

  def add_planetesimals
    (1..random(10..100)).each do |name|
      add_planetesimal(name)
    end
  end

  def add_planetesimal(name)
    o = @p.add_object name
    o.position = select_position()
    o.velocity = select_velocity_based_on(o.position)
    o.mass = random(0.2..1)
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
    orbital_tangent(position) * random(0.6..0.8)
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
    @sun = @p.find "sun"
    sun_offset = @sun.position - @origin
    @p.objects.each do |object|
      draw(screen, object.position - sun_offset)
    end
  end

  def draw(screen, point)
    screen.draw_cell(point.x, point.y, Color.black)
  end

  def sporadically_clean_up(screen)
    @step += 1;
    if (@step > @clear_limit)
      @step = 0
      screen.clear_screen
      @clear_limit *= 1.4
      delete_objects_too_far_from_sun
    end
  end

  def delete_objects_too_far_from_sun
    @p.objects.each do |object|
      if @sun.distance(object) > 10000
        @p.delete(object.name)
      end
    end
  end
end

CellularAutomaton.start do
  title "Orbit"
  world_size(1000, 1000)
  cell_size(1)
  clear_screen_each_step false
  world OrbitWorld
end
