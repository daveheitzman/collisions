class Ship < Box
  COLOR = Color[133, 133, 133]
  MAX_VELOCITY=200
  # SHOOT_SOUND=MutableSound['shoot.wav']
  # SHOOT_SOUND=MutableSound['laser-03.wav']
  # CANNON_SOUND=MutableSound['cannon.wav']
  THRUST_SOUND=MutableSound['thrust.wav']
  # SHIELD_SOUND=MutableSound['shields_on.wav']
  SHIELD_SOUND=MutableSound['shields_on.ogg']
  THRUST_SOUND_WAIT=0.7
  # todo: make prettier immune state 
  IMMUNE_COLORS=(0..17).map{ |t|  Color[ 120+t*2, 210-t*2, 140+t*2  ] }
  BULLET_TYPES=[Cannon, Bullet ]
  DEFAULT_RADIUS=5
  attr_accessor :x, :y, :width, :height, :velocity 
  attr_reader  :p_rot, :velocity_x, :velocity_y, :shield_end, :shield_radius

  def initialize(scene, x = 0, y = 0)
    super
    @next_bullet_allowed_at = 0 
    @bullet_off_delay = 0.94 - 0.01 * @scene.level
    @shield_end = -1
    @thrust_factor = 1.1 + 0.04 * @scene.level
    @shield_time = 3.37 + 0.06 * @scene.level
    @x = x
    @y = y
    @in_collision=false
    @width = 13
    @height = 18
    @radius=DEFAULT_RADIUS    
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

  def thrust(elapsed)
    if @scene.elapsed_total - @thrust_sound_last  > THRUST_SOUND_WAIT
      @thrust_sound_last=@scene.elapsed_total
      THRUST_SOUND.play
    end 
    new_vector = collide( [@speed, 1, @dir],[@thrust_factor, 1 , @p_rot ])
    @dir = new_vector[2]
    @speed = new_vector[0]
  end 

  def missile
    new_bullet
  end 
  
  def limit_velocity
    @speed = MAX_VELOCITY if @speed > MAX_VELOCITY
  end 

  def new_bullet
    if !@dead && @scene.elapsed_total > @next_bullet_allowed_at 
      b=@scene.game.player.bullet_type.new @scene, @x+(@width/2)-5, @y, self
      @next_bullet_allowed_at = @scene.elapsed_total + b.bullet_off_delay
      # if b.is_a?(Cannon)
      #   # CANNON_SOUND.play
      # else
      #   # SHOOT_SOUND.play
      # end 
      @scene.add_bullet b 
    end   
  end 
  
  def trigger_released
    #player has let up the 'z' fire key
    @next_bullet_allowed_at = (@scene.elapsed_total + ( @next_bullet_allowed_at - @scene.elapsed_total  ) * (0.451  ) )     
  end 
  
  def draw_triangle(d,rot, x=nil, y=nil)
    x ||= @x
    y ||= @y
    color= @in_collision ? Color[144, 144, 144] : COLOR
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

      d.translate x, y
      d.rotate rot

      d.begin_shape
      d.move_to 0,0
      d.move_to 0,-(@height/2)
      d.line_to @width/2,(@height/2)
      d.line_to -(@width/2),(@height/2)
      d.line_to 0,-(@height/2)
      d.end_shape
      d.stroke_shape
      # d.fill_shape

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
    tmp_radius= shield_active? ? @shield_radius : @radius
    in_collision=
      if thing.is_a?(Roid) 
        dist=( (thing.x-@x)**2 + (thing.y-@y)**2 ) ** 0.5
        in_collision = dist < (thing.radius + tmp_radius) 
        @dead=true if in_collision && !immune? 
        in_collision
      elsif thing.is_a?(PowerUp) || thing.is_a?(Bullet) || thing.is_a?(Alien)
        c=thing.center 
        sc=center 
        dist=( (c[0]-@x)**2 + (c[1]-@y)**2 ) ** 0.5
        dist < (thing.radius + @radius)*1.6 
      else
        false
      end
  end

  def shield_color 
    # @shield_color ||= Color[122,122,124]
    @shield_color ||= Color[230,130,154]
  end 

  def shield
    return if shield_active? 
    scene.game.player.lose_shield
    SHIELD_SOUND.play
    @shield_end = @scene.elapsed_total + @shield_time
  end 

  def shield_active?  
    active=@scene.elapsed_total < @shield_end
    if !active 
      SHIELD_SOUND.stop
    end 
    active
  end 

  def set_bullet_type(type, duration) #seconds 
    @scene.game.player.set_bullet_type(type)    
    @bullet_type_duration = duration 
  end  
end

