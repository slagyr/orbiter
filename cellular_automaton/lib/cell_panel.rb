

class CellPanel < JPanel
  def init(xcells, ycells, cell_size, clear_screen, world_class)
    @xcells = xcells
    @ycells = ycells
    @cell_size = cell_size
    @clear_screen = clear_screen
    @world_class = world_class
    @world = world_class.new(xcells, ycells)
  end

  def paintComponent(g)
    super if @clear_screen
    @screen = g
    @world.step(self)
  end

  def draw_cell(x,y,color)
    @screen.setColor(color)
    @screen.fillRect(x*@cell_size, y*@cell_size, @cell_size, @cell_size)
  end

  def clear_screen
    @screen.setColor(Color.white)
    @screen.fillRect(0,0,@xcells*@cell_size, @ycells*@cell_size)
  end
end