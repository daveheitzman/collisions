class Hero < Box
  COLOR = Color[33, 122, 248]
  MAX_VELOCITY=400
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
  end

  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2
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
    # if @velocity_x > 0.1
    #   @velocity_x *= 0.85
    # elsif @velocity_x < -0.1
    #   @velocity_x *= 1.15
    # else
    #   @velocity_x -= 11.5
    # end 
    @velocity_x -= 11.5
    @velocity_x = -MAX_VELOCITY if @velocity_x < -MAX_VELOCITY
  end 
  
  def right 
    # if @velocity_x < -0.1
    #   @velocity_x *= 0.85
    # elsif @velocity_x > 0.1
    #   @velocity_x *= 1.15
    # else
    #   @velocity_x += 11.5
    # end 
    @velocity_x += 11.5
    @velocity_x = MAX_VELOCITY if @velocity_x > MAX_VELOCITY
  end  

  def new_bullet
    Sound['shoot.wav'].play
    b=Bullet.new @x+(@width/2)-5, @y
    # b=Bullet.new 250, 250
    # b.velocity_y = -15
    b.velocity_x = 0.2*@velocity_x
    return b
  end 

end