class Physics
  class Point < Coordinate
    def move(v)
      @x += v.x
      @y += v.y
    end

    def distance(p)
      dx = dx(p)
      dy = dy(p)
      ds = dx*dx + dy*dy
      Math.sqrt(ds)
    end

    def slope(p)
      dy = dy(p)
      dx = dx(p)
      if (dx != 0)
        dy/dx
      else
        nil
      end
    end

    def dx(p)
      x - p.x
    end

    def dy(p)
      y - p.y
    end
  end
end