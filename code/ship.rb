class Ship < Box
  COLOR = Color[133, 133, 133]
  MAX_VELOCITY=200
  # SHOOT_SOUND=MutableSound['shoot.wav']
  SHOOT_SOUND=MutableSound['laser01.wav']
  CANNON_SOUND=MutableSound['cannon.wav']
  THRUST_SOUND=MutableSound['thrust.wav']
  SHIELD_SOUND=MutableSound['shields_on.wav']
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
    @bullet_off_delay = 0.44 - 0.01 * @scene.level
    @shield_end = -1
    @thrust_factor = 1.1 + 0.04 * @scene.level
    @shield_time = 1.37 + 0.06 * @scene.level
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
    handle_power_ups(elapsed)
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

    # @speed +=  @thrust_factor * ( Math.cos( @p_rot - @dir ) + Math.sin(@p_rot - @dir) )
    # @dir +=  -1 * @thrust_factor * ( @dir - Math::PI/4 @p_rot )/100
    # @dir +=  @thrust_factor * ( Math.sin( @dir - @p_rot ) - Math.cos( HALF_PI + @dir - @p_rot ) )/100
    # @dir +=  @thrust_factor * ( Math.sin( @dir - @p_rot ) + Math.cos( HALF_PI/2 + @dir - @p_rot ) )/100
    # @dir +=  -1*@thrust_factor * ( Math.sin( @dir - @p_rot  )  )/50
    # @dir = Math.atan(@velocity_x / @velocity_y)
    # sin is how much goes into changing the direction 
    
    # add_to_dir = Math.sin(@p_rot-@dir) 
    # add_to_speed = Math.cos(@p_rot-@dir)
    # # puts 'add_to_speed ' + add_to_speed.to_s 
    # @rot_velocity ||= 0.02
    # # @dir += add_to_dir * @rot_velocity
    # # @speed += add_to_speed * @thrust_factor
    # @speed = MAX_VELOCITY if @speed > MAX_VELOCITY
    # # @dir = @p_rot - ( @speed * add_to_dir)
    # # @dir = @p_rot - ( Math::PI * add_to_dir)

    # @dir = @dir + ( (@dir-@p_rot) * Math.sin(@p_rot-@dir) * ( @thrust_factor/(@thrust_factor +  @speed) ) )


    # @velocity_x = ( Math.cos(@p_rot-Math::PI/2) * @thrust_factor ) + @velocity_x
    # @velocity_y = ( Math.sin(@p_rot-Math::PI/2) * @thrust_factor ) + @velocity_y 
    # speed = ( @velocity_x**2 + @velocity_y**2 )**0.5
    # dir = Math.atan2(@velocity_x,-@velocity_y)  rescue 0
    
    @dir_factor ||= 0.01
    @thrust_factor=1.5
    # vx1 = Math.cos( @dir-HALF_PI )*@speed 
    # vy1 = Math.sin( @dir-HALF_PI )*@speed 

    # vx2 = Math.cos( @p_rot-HALF_PI )*@thrust_factor
    # vy2 = Math.sin( @p_rot-HALF_PI )*@thrust_factor
    
    puts 'dir before ' + @dir.to_s 
    puts 'speed before ' + @speed.to_s 
    # vxd = Math.cos( @dir )*@speed - Math.cos( @p_rot - HALF_PI)*@thrust_factor
    # vyd = Math.sin( @dir )*@speed - Math.sin( @p_rot - HALF_PI )*@thrust_factor
    vxd = Math.cos( @p_rot - HALF_PI)*@thrust_factor
    vyd = Math.sin( @p_rot  - HALF_PI)*@thrust_factor
    vel_x=@velocity_x + vxd 
    vel_y=@velocity_y + vyd 
    dir = Math.atan2( vel_x  , -vel_y )
    speed = ( (vel_x )**2 + (vel_y)**2 )**0.5
    @dir=dir 
    @speed=speed
    puts 'dir after ' + dir.to_s 
    puts 'speed after ' + speed.to_s 
    puts 'vxd ' + vxd.to_s 
    puts 'vyd ' + vyd.to_s 
    puts '-------- '

    
    # puts '@p_rot  ' + @p_rot.to_s 
    # puts '@thrust_factor  ' + @thrust_factor.to_s 
    # puts 'dir before ' + @dir.to_s 
    # puts 'speed before ' + @speed.to_s 
    # @speed += Math.cos(@p_rot - @dir) * @thrust_factor
    # # @speed = @speed  * @thrust_factor
    # # @dir += (@p_rot-@dir)*Math.sin(@p_rot-@dir) * ( @speed/(@speed + @thrust_factor+1000) ) 
    # @dir = @p_rot*@dir_factor + @dir 
    # @dir = (TWO_PI + @dir) % TWO_PI
    # puts 'dir after ' + @dir.to_s 
    # puts 'speed after ' + @speed.to_s 

    # puts 'dir after ' + dir.to_s 
    # puts 'speed after ' + speed.to_s 

    # cos is how much goes into changing the speed 

    # @dir = if @velocity_y == 0.0 
    #   @velocity_x > 0 ? Math::PI * 0.5  : 1.5 * Math::PI
    # elsif @velocity_x == 0.0 
    #   @velocity_y > 0 ? Math::PI : 0
    # else 
    #   Math.atan(-@velocity_y / @velocity_x)          
    # end
    # @dir += @thrust_factor * ( @p_rot - @dir ) * elapsed * 0.1  
    # @dir = @dir % TWO_PI
    # @speed += @thrust_factor 
  end 

  def missile
    new_bullet
  end 
  
  def limit_velocity
    # @velocity_y = MAX_VELOCITY if @velocity_y > MAX_VELOCITY
    # @velocity_x = MAX_VELOCITY if @velocity_x > MAX_VELOCITY
  end 

  def new_bullet
    # SHOOT_SOUND.play
    if !@dead && @scene.elapsed_total > @next_bullet_allowed_at 
      @next_bullet_allowed_at = @scene.elapsed_total + @bullet_off_delay
      b=@scene.game.player.bullet_type.new @scene, @x+(@width/2)-5, @y, self
      # b=Cannon.new @scene, @x+(@width/2)-5, @y, self
      if b.is_a?(Cannon)
        CANNON_SOUND.play
      else
        SHOOT_SOUND.play
      end 
      # b.velocity_x = (Math.cos(@p_rot-Math::PI/2) * b.velocity_x) + @velocity_x
      # b.velocity_y = (Math.sin(@p_rot-Math::PI/2) * b.velocity_y) + @velocity_y 
      @scene.add_bullet b 
    end   
  end 
  
  def trigger_released
    #player has let up the 'z' fire key
    @next_bullet_allowed_at = (@scene.elapsed_total + ( @next_bullet_allowed_at - @scene.elapsed_total  ) * (0.351  ) )     
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
 
  def handle_power_ups(elapsed)
    #bullets

    # @bullet_type_duration ||= -1 

    # if @bullet_type_duration < 0
    #   @bullet_type=Bullet
    # else 
    #   @bullet_type=Cannon
    #   @bullet_type_duration -= elapsed 
    # end 

    #invincibility
    #speed? 
  end 

  def set_bullet_type(type, duration) #seconds 
    @scene.game.player.set_bullet_type(type)    
    @bullet_type_duration = duration 
  end  
end

