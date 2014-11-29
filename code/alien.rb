class Alien < Ship
  COLOR = Color[244, 22, 18]
  SHOOT_SOUND = MutableSound['laser05.wav']
  FLY_SOUND = MutableSound['alien_present.wav']
  EXPLOSION_SOUNDS=[]

  def initialize(scene, x = 0, y = 0)
    super 
    @sounds=[SHOOT_SOUND,FLY_SOUND]+EXPLOSION_SOUNDS
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
    @radius = 30
    @shoot_delay=1.3 - @scene.level*0.05
    @shoot_delay_timer = 0
    FLY_SOUND.play.repeat
  end 

  def draw(d)
    return if @dead 
    bulb_x=15
    bulb_y=13
    d.push
      d.stroke_color = COLOR
      d.fill_color = COLOR
      d.stroke_width = 2
      d.translate x, y
      d.begin_shape
      d.move_to 0,0
      d.line_to -4,0
      d.line_to -4,5
      d.curve_to  -bulb_x, bulb_y, -bulb_x + 5, bulb_y-9
      d.curve_to 0, bulb_y + 10, -bulb_x + 5 , bulb_y + 9
      d.curve_to bulb_x, bulb_y , bulb_x - 5 , bulb_y + 9 
      d.curve_to 4,5, bulb_x - 5 , bulb_y - 9
      d.line_to 4,0
      d.line_to 0,0
      d.end_shape
      d.stroke_shape

      # d.fill_shape
    d.pop
  end 

  def update(elapsed)
    if @dead 
      silence! 
      return 
    end 
    if @x < 0 || @x > @scene.width || @y < 0 || @y > @scene.height
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
    if !@dead 
      SHOOT_SOUND.play
      # SHOOT_SOUND.play
      vel_matrix=[@velocity_x > 0 ? 1 : -1 , @velocity_y > 0 ? 1 : -1  ]
      rot = rand * TWO_PI
      vel=270+@scene.level*8
      b=Bullet.new @scene, @x+(@width/2)+5, @y
      b.velocity_x = (Math.cos(rot) * vel)*vel_matrix[0] + @velocity_x
      b.velocity_y = (Math.sin(rot) * vel)*vel_matrix[1] + @velocity_y

      # b.velocity_x = if @velocity_x < 0 
      #   @velocity_x - (Math.cos(rot).abs * vel)
      # else
      #   @velocity_x + (Math.cos(rot).abs * vel)
      # end 
      # b.velocity_y = if @velocity_y < 0 
      #   @velocity_y - (Math.sin(rot).abs * vel)
      # else
      #   @velocity_y + (Math.sin(rot).abs * vel)
      # end 
      @scene.add_alien_bullet b 
    end   
  end 

  def immune? 
    false
  end 
  
  def colliding?(thing)
    tmp_radius= shield_active? ? @shield_radius : @radius
    in_collision=
      if thing.is_a?(Ship) || thing.is_a?(Alien)
        c=thing.center 
        sc=center 
        dist=( (c[0]-@x)**2 + (c[1]-@y)**2 ) ** 0.5
        dist < (thing.radius + @radius)*0.1
      else
        false
      end
  end

  def play_explosion
    # EXPLOSION_SOUNDS.sample.play
  end 
end

