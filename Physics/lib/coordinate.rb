class Physics
  class Coordinate
    attr_accessor :x, :y
    def initialize(x, y)
      @x = x
      @y = y
    end

    def to_s
      "(#{@x}, #{@y})"
    end

    def ==(v)
      @y == v.y && @x == v.x
    end

    def +(v)
      self.class.new(x+v.x, y+v.y)
    end

    def -(v)
      self.class.new(x-v.x, y-v.y)
    end

    def /(d)
      d = d.to_f
      self.class.new(x/d, y/d)
    end

    def *(d)
      d = d.to_f
      self.class.new(x*d, y*d)
    end
  end
end
