class ShipSegment < Roid
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision, :color
  attr_reader  :p_rot

  MAX_SEGMENTS=150 

  def initialize(scene,ship)
    super scene, ship.x, ship.y
    @x = ship.x
    @y = ship.y
    xdelt=rand*10
    ydelt=rand*10
    @x1 = -xdelt
    @y1 = -ydelt
    @x2 = xdelt
    @y2 = ydelt
    @color=if ship.is_a?(Roid)
      Roid::COLOR 
    else 
      Ship::COLOR
    end 
    @velocity_x = ship.velocity_x > 0 ? 38 + ship.velocity_x * rand*2.2 : -38 + -ship.velocity_x * rand*2.2
    @velocity_y = ship.velocity_y > 0 ? 38 + ship.velocity_y * rand*2.2 : -38 + -ship.velocity_y * rand*2.2

    @p_rot = TWO_PI*rand
    @p_rot_delta=rand*0.06
    @ttl=(35+rand*45).to_i
    @in_collision = false
  end

  def draw(d)
    draw_line(d,@p_rot)
  end

  def update(elapsed)
    super
  end
    
  def draw_line(d,rot)
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


end