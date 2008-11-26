class Physics
  class Vector < Coordinate
    def magnitude
      Math.sqrt(x*x + y*y)
    end

    def almost_equal?(v)
      (x-v.x).abs < 0.0001 && (y-v.y).abs < 0.0001
    end
  end
end
