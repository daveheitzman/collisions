class Ship < Box
  COLOR = Color[133, 47, 222]
  MAX_VELOCITY=200
  # SHOOT_SOUND=MutableSound['shoot.wav']
  SHOOT_SOUND=MutableSound['laser01.wav']
  THRUST_SOUND=MutableSound['thrust.wav']
  THRUST_SOUND_WAIT=0.7
  # todo: make prettier immune state 
  IMMUNE_COLORS=(0..17).map{ |t|  Color[ 120+t*2, 210-t*2, 140+t*2  ] }

  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :p_rot, :velocity_x, :velocity_y, :shield_end, :shield_radius

  def initialize(scene, x = 0, y = 0)
    super
    @next_bullet_allowed_at = 0 
    @bullet_off_delay = 0.34 - 0.01 * @scene.level
    @shield_end = -1
    @thrust_factor = 1.1 + 0.04 * @scene.level
    @shield_time = 1.37 + 0.06 * @scene.level
    @x = x
    @y = y
    @in_collision=false
    @width = 13
    @height = 18
    @velocity_x = 0
    @velocity_y = 0
    @p_rot=0
    @radius=5    
    @thrust_sound_last=0
    @shield_radius=@radius*4
  end

  def draw(d)
    unless @dead 
      d.stroke_color = COLOR
      d.stroke_width = 2

      draw_triangle(d, @p_rot )

      d.fill_color = COLOR
      @collided = false
    end 
  end

  def update(elapsed)
    super
    limit_velocity
  end
    
  def left
    @p_rot -= 0.1
    @p_rot = @p_rot % TWO_PI
  end 
  
  def right 
    @p_rot += 0.1
    @p_rot = @p_rot % TWO_PI
  end  

  def thrust
    if @scene.elapsed_total - @thrust_sound_last  > THRUST_SOUND_WAIT
      @thrust_sound_last=@scene.elapsed_total
      THRUST_SOUND.play
    else

    end 
      @velocity_x = ( Math.cos(@p_rot-Math::PI/2) * @thrust_factor ) + @velocity_x
      @velocity_y = ( Math.sin(@p_rot-Math::PI/2) * @thrust_factor ) + @velocity_y 
  end 

  def missile
    new_bullet
  end 
  
  def limit_velocity
    @velocity_y = MAX_VELOCITY if @velocity_y > MAX_VELOCITY
    @velocity_x = MAX_VELOCITY if @velocity_x > MAX_VELOCITY
  end 

  def new_bullet
    # SHOOT_SOUND.play
    if @scene.elapsed_total > @next_bullet_allowed_at 
      @next_bullet_allowed_at = @scene.elapsed_total + @bullet_off_delay
      SHOOT_SOUND.play
      b=Bullet.new @scene, @x+(@width/2)-5, @y
      b.velocity_x = (Math.cos(@p_rot-Math::PI/2) * 300) + @velocity_x
      b.velocity_y = (Math.sin(@p_rot-Math::PI/2) * 300) + @velocity_y 
      @scene.add_bullet b 
    end   
  end 
  
  def trigger_released
    #player has let up the 'z' fire key
    @next_bullet_allowed_at = @scene.elapsed_total + ( @next_bullet_allowed_at - @scene.elapsed_total  ) * 0.75     
  end 
  
  def draw_triangle(d,rot)
    color= @in_collision ? Color[233, 122, 200] : COLOR
    @last_immune_color ||= 0    
    if immune? 
      @last_immune_color += 1
      @last_immune_color %= IMMUNE_COLORS.size 
      # color = Color[ (rand*128).to_i, (rand*128).to_i, (191+rand*64).to_i  ]
      color = IMMUNE_COLORS[@last_immune_color]
    end 
    d.push
      d.stroke_color = color
      d.fill_color = color
      d.stroke_width = 2

      d.translate @x, @y
      d.rotate rot

      d.begin_shape
      d.move_to 0,0
      d.move_to 0,-(@height/2)
      d.line_to @width/2,(@height/2)
      d.line_to -(@width/2),(@height/2)
      d.line_to 0,-(@height/2)
      d.end_shape
      d.stroke_shape
      d.fill_shape

      if shield_active?
        d.stroke_color = shield_color
        d.stroke_ellipse 0, 0, @shield_radius, @shield_radius 
        d.stroke_shape
      end 
      d.stroke_color = color
      d.fill_color = color
    d.pop
  end

  def colliding?(thing)
    @in_collision = @in_collision || 
    if thing.is_a?(Roid)
      dist=( (thing.x-@x)**2 + (thing.y-@y)**2 ) ** 0.5
      dist < (thing.radius + @radius) 
    else
      false
    end
    # if @in_collision
    #   puts 'ship collided'
    # end  
    @in_collision = @in_collision && !immune? 
    @dead=true if @in_collision
  end
  def shield_color 
    Color[230,130,154]
  end 

  def shield
    return if shield_active? 
    puts 'shield'
    scene.game.player.lose_shield
    @shield_end = @scene.elapsed_total + @shield_time
  end 

  def shield_active?  
    @scene.elapsed_total < @shield_end
  end 

end

