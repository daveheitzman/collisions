class Alien < Ship
  COLOR = Color[244, 22, 18]
  # SHOOT_SOUND = Sound['.wav']
  # FLY_SOUND = Sound['.wav']
  
  def initialize(scene, x = 0, y = 0)
    super 
    if rand < 0.5 
      @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
      @x=10
      @velocity_y = 0
      @velocity_x = (150 + @scene.level*15)
    else
      @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
      @x=@scene.width - 10
      @velocity_y = 0
      @velocity_x = (150 + @scene.level*15)*-1.0
    end 
    @height=40
    @width=40
    @shoot_delay=1.3 - @scene.level*0.05
    @shoot_delay_timer = 0
  end 

  def draw(d)
    return if @dead 
    d.push
      d.stroke_color = COLOR
      d.fill_color = COLOR
      d.stroke_width = 2
      d.translate x, y
      d.rotate p_rot
      d.begin_shape
      d.move_to 0,0
      d.line_to -4,0
      d.line_to -4,5
      d.curve_to -16,15, -11,6
      d.curve_to 0,25, -11, 24
      d.curve_to 16,15, 11,24
      d.curve_to 4,5, 11, 6
      d.line_to 4,0
      d.line_to 0,0
      d.end_shape
      d.stroke_shape

      # d.fill_shape
    d.pop
  end 

  def update(elapsed)
    return if @dead 
    if @x < 0 || @x > @scene.width || @y < 0 || @y > @scene.width
    # if @x < 0 || @x > @scene.width 
      die!
    end 
    super 
    @shoot_delay_timer -= elapsed
    if @shoot_delay_timer < 0
      @shoot_delay_timer = @shoot_delay 
      new_bullet
    end 
  end 

  def new_bullet
    # SHOOT_SOUND.play
    if !@dead 
      # SHOOT_SOUND.play
      rot = rand * TWO_PI
      vel=210+@scene.level*8
      b=Bullet.new @scene, @x+(@width/2)+5, @y

      b.velocity_x = if @velocity_x < 0 
        @velocity_x - (Math.cos(rot).abs * vel)
      else
        @velocity_x + (Math.cos(rot).abs * vel)
      end 
      b.velocity_y = if @velocity_y < 0 
        @velocity_y - (Math.sin(rot).abs * vel)
      else
        @velocity_y + (Math.sin(rot).abs * vel)
      end 
      @scene.add_alien_bullet b 
    end   
  end 

end

