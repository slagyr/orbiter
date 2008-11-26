require 'orbit_world'

module Ecliptic

  def scene_opened(e)

    world = OrbitWorld.new(area.width, area.height)

    @pen = self.pen

    @animation = animate(:update_per_second => 1000) do
      begin
        world.step(self)
      rescue Exception => e
        puts e
        puts e.backtrace
        @animation.stop
      end
    end

  end  

  def draw_cell(x, y, color)
    @pen.color = color
    @pen.fill_rectangle(x, y, 1, 1)
  end

  def clear_screen
    @pen.color = "white"
    @pen.fill_rectangle(0, 0, area.width, area.height)
  end

end