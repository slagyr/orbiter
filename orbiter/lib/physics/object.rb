class Physics
  class Object
    attr_accessor :velocity, :position, :mass, :force
    attr_reader :name
    def initialize(name)
      @name = name
      @velocity = Velocity.new(0, 0)
      @position = Point.new(0, 0)
      @mass = 0
      @force = Force.new(0, 0)
    end

    def to_s
      "[#{@name}: m=#{@mass}, p=#{@position}, v=#{@velocity}, f=#{@force}]"
    end

    def move
      @position.move @velocity
    end

    def clear_force
      @force = Force.new(0, 0)
    end

    def distance(object)
      @position.distance(object.position)
    end

    def dx(object)
      position.dx(object.position)
    end

    def dy(object)
      position.dy(object.position)
    end

    def add_force(f)
      @force += f
    end
  end
end