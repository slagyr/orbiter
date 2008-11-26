module Space
  SPECTRUM = ["black", "chocolate", "green", "tan", "fire_brick", "red", "orange", "goldenrod", "light blue", "violet"]
  MASS_INDEX = [[0]*1,[1]*1,[2]*2,[3]*3,[4]*5,[5]*8,[6]*13,[7]*21,[8]*34,[9]*55].flatten
  INDECES = MASS_INDEX.length

  def draw_cell(x, y, weight, magnification)
    index = mass_index(weight)
    @pen.color = SPECTRUM[index]
    if index <= 1
      @pen.fill_rectangle(x, y, 1, 1)
    else
      radius = (index/magnification).to_i
      radius = radius<1 ? 1 : radius
      diameter = radius*2
      @pen.fill_oval(x-radius, y-radius, diameter, diameter)
    end
  end

  def mass_index(weight)
    weight_ratio = (weight/400.0)
    selected_index = (weight_ratio * INDECES).to_i
    MASS_INDEX[selected_index]
  end

  def clear_screen
    @pen.color = "white"
    @pen.fill_rectangle(0, 0, area.width, area.height)
    @pen.color = "black"
  end

  def start
    @pen = self.pen
    clear_screen
    @world = OrbitWorld.new(area.width, area.height)

    @animation = animate(:update_per_second => 1000) do
      begin
        @world.step(self)
      rescue Exception => e
        puts e
        puts e.backtrace
        @animation.stop
      end
    end
  end

  def stop
    @animation.stop
  end

  def zoom_in
    @world.zoom_in
  end

  def zoom_out
    @world.zoom_out
  end

end