gem "rspec"
require "spec"
require 'bauble'
Bauble.use("../../Physics")

VZERO = Physics::Velocity.new(0,0)
ORIGIN = Physics::Point.new(0,0)
FZERO = Physics::Force.new(0,0)

describe Physics do
  before(:each) do
    @p = Physics.new
  end

  after(:each) do
  end

  it "should have no objects to start with" do
    @p.should have(0).objects
  end

  it "should accept a default object with a name." do
    @p.add_object("Bob")
    @p.should have(1).objects
    bob = @p["Bob"]
    bob.velocity.should == VZERO
    bob.position.should == ORIGIN
    bob.mass.should == 0
  end

  it "should move one object according to its velocity" do
    @p.add_object("O")
    @p["O"].velocity = Physics::Velocity.new(1,1)
    @p.tic 1
    NEW_LOCATION = Physics::Point.new(1,1)
    @p["O"].position.should == NEW_LOCATION
  end

  it "should move many objects according to their velocities" do
    @p.add_object("P")
    @p.add_object("Q")
    @p["P"].velocity = Physics::Velocity.new(1,0);
    @p["Q"].velocity = Physics::Velocity.new(-1,-1);
    @p["Q"].position = Physics::Point.new(10,10)

    @p.tic 2
    @p["P"].position.should == Physics::Point.new(2,0)
    @p["Q"].position.should == Physics::Point.new(8,8)
  end

  it "should cause two objects to attract by gravity" do
    @p.add_object(:P)
    @p[:P].position = Physics::Point.new(1,1)
    @p[:P].mass = 1

    @p.add_object(:Q)
    @p[:Q].mass = 1

    @p.calculate_forces

    #F=m1m2/d^2 == 1/2.
    #fc is the component in X and Y (both equal in this case)
    #fc = F*dc/d where dc is the component of distance (one in this case)
    #d is simply sqrt(2)  So 1/2 * 1/sqrt(2) = sqrt(2)/4)
    
    fc = Math.sqrt(2)/4

    @p[:P].force.should be_almost_equal(Physics::Force.new(-fc, -fc))
    @p[:Q].force.should be_almost_equal(Physics::Force.new(fc,fc))
  end

  it "should cause three objects to atract by gravity" do
    a = @p.add_object(:A)
    b = @p.add_object(:B)
    c = @p.add_object(:C)

    a.mass = 1
    b.mass = 2
    c.mass = 3

    a.position = Physics::Point.new(1,1)
    b.position = Physics::Point.new(1,-1)

    @p.calculate_forces

    #I calculated all these by hand.  It's not too hard.
    a.force.should be_almost_equal(Physics::Force.new(-1.0606601, -1.5606601))
    b.force.should be_almost_equal(Physics::Force.new(-2.121320343, 2.621320343))
    c.force.should be_almost_equal(Physics::Force.new(3.1819805, -1.060660171))
  end

  it "should cause objects under force to accelerate" do
    a = @p.add_object(:A)
    a.mass=2
    a.force = Physics::Force.new(1,0);
    @p.apply_forces
    a.velocity.should == (Physics::Velocity.new(0.5, 0))
  end

  it "should cause two massive objects to move together" do
    a = @p.add_object(:A)
    a.mass = 1
    a.position = Physics::Point.new(10,10)

    b = @p.add_object(:B)
    b.mass = 1
    b.position = Physics::Point.new(-10,-10)

    d = a.distance b

    @p.tic 1

    d.should > (a.distance b)
  end

  it "should detect collisions and merge the two objects" do
    a = @p.add_object :A
    a.position = Physics::Point.new(1,1)
    a.mass = 1
    a.velocity = Physics::Velocity.new(0,-1)

    b = @p.add_object :B
    b.position = Physics::Point.new(1,2)
    b.mass = 2
    b.velocity = Physics::Velocity.new(0,1)

    @p.detect_collisions

    @p.should have(1).objects
    c = @p["A-B"]
    c.should_not be_nil

    c.mass.should == 3
    c.velocity.should == Physics::Velocity.new(0,1.0/3)
    c.position.should == Physics::Point.new(1,1.5)
  end

end

describe Physics::Object do
  before(:each) do
    @o = Physics::Object.new("object")
  end

  it "should have a name, zero mass, at origin, and no velocity" do
    @o.velocity.should == VZERO
    @o.position.should == ORIGIN
    @o.mass.should == 0
    @o.name.should == "object"
  end

  it "should accept a mass" do
    @o.mass = 4
    @o.mass.should == 4
  end

  it "should accept a velocity" do
    V = Physics::Velocity.new(1,1)
    @o.velocity = V
    @o.velocity.should == V
  end

  it "should accept a position" do
    P = Physics::Point.new(2,2)
    @o.position = P
    @o.position.should == P
  end
end

describe Physics::Vector do
  before(:each) do
    @v = Physics::Vector.new(1,1)
  end

  it "should be divisible" do
    half = @v/2
    half.should == (Physics::Vector.new(0.5,0.5))
  end
end