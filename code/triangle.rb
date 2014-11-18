class Hero < Box
  COLOR = Color[33, 122, 248]
  MAX_VELOCITY=400
  TWO_PI=Math::PI*2
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled 

  def initialize(x = 0, y = 0)
    super
    @x = x
    @y = y
    @in_collision=false
    @width = 11
    @height = 20
    @filled = true
    @velocity_x = 0
    @velocity_y = 0
    @p_rot=0
  end


  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2

    draw_polygon(d, [600,600], @p_rot, 3, 30)

    d.stroke_rectangle(@x, @y, @width, @height)

    if @filled
      d.fill_color = COLOR
      d.fill_rectangle(@x, @y, @width, @height)
      @collided = false
    end
  end

  def update(game, elapsed)
    super
    @velocity_x *= 0.99
    @in_collision=false
  end
    
  def left
    @p_rot -= 0.1
    @p_rot = @p_rot % TWO_PI
    @velocity_x -= 11.5
    @velocity_x = -MAX_VELOCITY if @velocity_x < -MAX_VELOCITY
  end 
  
  def right 
    @p_rot += 0.1
    @p_rot = @p_rot % TWO_PI
    @velocity_x += 11.5
    @velocity_x = MAX_VELOCITY if @velocity_x > MAX_VELOCITY
  end  

  def new_bullet
    Sound['shoot.wav'].play
    b=Bullet.new @x+(@width/2)-5, @y
    b.velocity_x = 0.2*@velocity_x
    return b
  end 

  def draw_polygon(d, position, rotation, side_count, radius)
    angle_per = Math::PI * 2 / side_count

    d.push
      d.stroke_color = COLOR
      d.stroke_width = 2

      d.translate position.first,position.last
      d.rotate rotation

      d.begin_shape
        d.move_to radius, 0

        side_count.times do |i|
          d.line_to radius * Math.cos(angle_per * i),
                      radius * Math.sin(angle_per * i)
        end
      d.end_shape

      d.stroke_shape
    d.pop
  end

  def draw_triangle
    d.push
    d.begin_shape
    d.move_to 100,100
    d.line_to 150,150
    d.line_to 100,150
    d.line_to 100,100
    d.end_shape
    d.fill_shape
    d.stroke_shape
    d.pop
  end

end