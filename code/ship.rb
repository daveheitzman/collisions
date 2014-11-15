class Ship < Box
  COLOR = Color[133, 47, 222]
  MAX_VELOCITY=400
  SHOOT_SOUND=Sound['shoot.wav']
  THRUST_SOUND=Sound['thrust.wav']
  THRUST_SOUND_WAIT=0.7
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled, :p_rot , :game 

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
    @thrust_sound_last=0
  end


  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2

    draw_triangle(d, @p_rot )

    if @filled
      d.fill_color = COLOR
      @collided = false
    end
  end

  def update(game, elapsed)
    super
    # @p_rot += elapsed 
    # @p_rot = @p_rot % TWO_PI
    # @velocity_x *= 0.99
    # @velocity_y *= 0.99
    @in_collision=false
  end
    
  def left
    # if @velocity_x > 0.1
    #   @velocity_x *= 0.85
    # elsif @velocity_x < -0.1
    #   @velocity_x *= 1.15
    # else
    #   @velocity_x -= 11.5
    # end 
    @p_rot -= 0.1
    @p_rot = @p_rot % TWO_PI
    # @velocity_x -= 11.5
    # @velocity_x = -MAX_VELOCITY if @velocity_x < -MAX_VELOCITY
  end 
  
  def right 
    # if @velocity_x < -0.1
    #   @velocity_x *= 0.85
    # elsif @velocity_x > 0.1
    #   @velocity_x *= 1.15
    # else
    #   @velocity_x += 11.5
    # end 
    @p_rot += 0.1
    @p_rot = @p_rot % TWO_PI
    # @velocity_x += 11.5
    # @velocity_x = MAX_VELOCITY if @velocity_x > MAX_VELOCITY
  end  

  def thrust
    if game.elapsed_total - @thrust_sound_last  > THRUST_SOUND_WAIT
      @thrust_sound_last=game.elapsed_total
      THRUST_SOUND.play
    else

    end 
    @velocity_x = (Math.cos(@p_rot-Math::PI/2) * 3) + @velocity_x
    @velocity_y = (Math.sin(@p_rot-Math::PI/2) * 3) + @velocity_y 
  end 

  def missile
    new_bullet
  end 


  def new_bullet
    SHOOT_SOUND.play
    b=Bullet.new @x+(@width/2)-5, @y
    b.velocity_x = (Math.cos(@p_rot-Math::PI/2) * 300) + @velocity_x
    b.velocity_y = (Math.sin(@p_rot-Math::PI/2) * 300) + @velocity_y 
    return b
  end 

  def draw_triangle(d,rot)
    d.push
      d.stroke_color = COLOR
      d.fill_color = COLOR
      d.stroke_width = 2

      d.translate @x, @y
      d.rotate rot

      d.begin_shape
      d.move_to 0,0
      d.move_to 0,-13
      d.line_to 8,8
      d.line_to -8,8
      d.line_to 0,-13
      d.end_shape

      d.stroke_shape
      d.fill_shape
    d.pop
  end


end