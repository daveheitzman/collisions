class ShipSegment < Roid
  COLOR = Color[255, 33, 44]
  MAX_VELOCITY=400
  SHOOT_SOUND=Sound['shoot.wav']
  THRUST_SOUND=Sound['thrust.wav']
  THRUST_SOUND_WAIT=0.7
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled, :p_rot , :game 

  def initialize(ship)
    super ship.x, ship.y
    @x = ship.x
    @y = ship.y
    xdelt=rand*10
    ydelt=rand*10
    @x1 = -xdelt
    @y1 = -ydelt
    @x2 = xdelt
    @y2 = ydelt

    @velocity_x = ship.velocity_x > 0 ? 15 + ship.velocity_x * rand*3 : -15 + -ship.velocity_x * rand*3
    @velocity_x = ship.velocity_y > 0 ? 15 + ship.velocity_y * rand*3 : -15 + -ship.velocity_y * rand*3

    @p_rot = TWO_PI*rand
    @p_rot_delta=rand*0.06
    @ttl=99999
    @in_collision = false
  end

  def draw(d)
      draw_line(d,@p_rot)
    unless @dead
    end 
  end

  def update(game, elapsed)
    super
  end
    
  def draw_line(d,rot)
    color = Ship::COLOR
    d.push
      d.stroke_color = color
      d.stroke_width = 2
      d.translate @x, @y
      d.rotate rot
      d.begin_shape
      d.move_to 0 , 0
      d.line_to @x1 , @y1
      d.line_to @x2 , @y2
      d.end_shape
      d.stroke_shape
    d.pop
  end

  def colliding?(thing)
    @in_collision = false
  end

end