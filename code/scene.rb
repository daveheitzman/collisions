class Scene
  BACKGROUND_COLOR=Color[25,25,25]
  BORDER_COLOR = Color[10, 10, 10]
  THRUST_SOUND_WAIT = 0.5
  GAME_FONT=Font['envy_code_r.ttf']

  attr_accessor  :width, :height
  attr_reader :box_count, :ship, :hero, :dead, :outcome , :level , :game, :bullets, :roids, :stl, :ttl

  def initialize( game, level )
    @ticks=0
    @game=game
    @level=level
    @width = 700
    @height = 650
    @roids = []
    @bullets = []
    @alien_bullets = []
    @schrapnel = []
    pu=PowerUp.new(self,100,200)
    pu.set_text("+")

    @stl = 9999999999999999
    @ttl = 9999999999999999
    @power_ups = []
    @outcome="died"
    @power_up_multiplier = ( 1 / (@level ** 0.5 ) ) * 0.012
    spawn_ship
    (2+level).times{ add_roid }
    @bullet_off_delay = -1
    @aliens=[]
    revive
  end

  def update( elapsed )
    @ticks += 1 
    @ttl -= 1
    @stl -= elapsed
    @bullets=[] if @ship.dead
    @dead = true if ( @ttl < 0 && @stl < 0 )
# puts "scene update #{@ttl} #{@stl} #{elapsed}"
    if !game_over? 
      if !@ship.dead 
        if @game.keyboard.released? :x
          @ship.trigger_released()        
        end 
        if @game.keyboard.pressing? :x
          @ship.missile()        
        end 
        @ship.thrust(elapsed) if game.keyboard.pressing? :up
        @ship.shield() if game.keyboard.pressing?( :z ) && game.player.shields > 0
        if game.keyboard.pressing? :left
          @ship.left()
        elsif game.keyboard.pressing? :right
          @ship.right()
        end
      end 
    end
    if @game.keyboard.pressing? :ctrl
      if @game.keyboard.pressing? :r
        @game.setup
      end 
    end 

    [@roids,[@ship], @aliens, @bullets,@alien_bullets, @schrapnel ].each do |a|
      a.each  do |t|
        t.update(elapsed)
      end 
    end 

    if !game_over?
      @ship.update( elapsed)
      # release power up 
      if rand < ( elapsed * @power_up_multiplier )
        @power_ups << [PowerUpExtraLife, PowerUpShield, PowerUpCannon].sample.new(self, (height-60)*rand + 30, (width-60)*rand+30 )
      end  

      if  rand < 20 * (0.2 + 0.1*@level )*( elapsed * @power_up_multiplier )
        # @aliens<<Alien.new( self )
        @aliens<<Alien.new( self ) unless @aliens.size > 0
      end  
    end 

    collide_boxes 

    @power_ups.each do |power_up|
      # next if power_up.dead || power_up.nil?
      power_up.update(elapsed)
      power_up.help(@ship) if @ship.colliding?(power_up) 
    end 

    roids_size = @roids.size 
    @power_ups.select!{ |p| p && !p.dead }
    @roids.select!{ |s| s && !s.dead }
    @schrapnel.select!{ |s| s && !s.dead }
    @bullets.select!{ |s| s && !s.dead }
    @alien_bullets.select!{ |s| s && !s.dead }
    @aliens.select!{ |s| s && !s.dead }

    if !game_over?
      if roids_size > 0 && @roids.empty?
        @ttl = -1
        @stl = 3
        @outcome="solved"
      end 
    end 
    freeze 
    true
  end

  def draw(display)
    draw_play_area display   
    [@roids,[@ship],@aliens, @alien_bullets, @bullets, @schrapnel ].each do |a|
      a.each  do |t|
        t.draw(display)
      end 
    end 
    if !game_over?
      @ship.draw(display)
    end 
    if game_over?
      display.fill_color = Color[111,111,111]
      display.text_font GAME_FONT
      display.text_size=30
      display.scale 1
      display.fill_text("Game Over", width/2-50, height/2 )
    end 
    #show level banner at start of scene
    if @ticks < 100 
      display.fill_color = Color[133,133,133]
      display.text_font GAME_FONT
      display.text_size=30
      display.scale 1
      display.fill_text("Level #{@level}", width/2-50, height/2 )
    end 
    @power_ups.each do |pu|
      pu.draw(display)
    end 

    do_score( display )     
  end

  def draw_play_area(display)
    display.fill_color=BACKGROUND_COLOR
    display.fill_rectangle(0, 0, @width, @height)
    display.stroke_width = 3
    display.stroke_color=BORDER_COLOR 
    display.stroke_rectangle(0, 0, @width, @height)
  end 

  def ship_explode_and_die
    @ship = ShipExploding.new(self, @ship)  
    @outcome='died'
    @ttl = -1 # the scene must end when the player dies 
    @stl = 2 # the scene must end when the player dies 
  end 

  def collide_boxes
    aliens_and_alien_bullets = (@aliens+@alien_bullets)
    hittable_by_ship_bullets = @roids + @aliens 

    aliens_and_alien_bullets.each_with_index do |ab, abi| 
      if @ship.colliding?(ab) 
        if @ship.shield_active? 
          ab.die!
        elsif !@ship.immune?
          ship_explode_and_die
        end 
      end 
    end 
    
    hittable_by_ship_bullets.each_with_index do |roid, i|
      next if roid.nil? || roid.dead

      if @ship.shield_active? && !@ship.immune? 
        dist=( (roid.x-@ship.x)**2 + (roid.y-@ship.y)**2 ) ** 0.5
        if dist < (roid.radius + @ship.shield_radius )
          @ship.make_immune(0.25)
          ang=Math.atan( (@ship.x-roid.x)/(0.00001+@ship.y-roid.y) )
          dot=Math.atan( (@ship.x)/(0.00001+@ship.y) )
          puts ang.to_s + "," + dot.to_s
          avg = ( ang + dot )/2
          @ship.new_direction(avg)
          player_kills_roid(roid)
        end 
      elsif @ship.colliding?(roid) 
        if @ship.shield_active?
          player_kills_roid(roid)
        elsif @ship.dead 
          ship_explode_and_die
        end 
      end 

      @bullets.each_with_index do |bullet, bi| 
        next if bullet.nil? 
        bullet_roid(bullet,roid)
      end 

      @alien_bullets.each_with_index do |bullet, bi| 
        next if bullet.nil? || roid.is_a?(Alien)
        bullet_roid(bullet,roid)
      end 
    end

  end 

  def bullet_roid(bullet,roid)
    if bullet.colliding?(roid)
      if bullet.class==Bullet
        # if anything hits a bullet , bullet and thing are dead
        bullet.die!
        roid.die!
        player_kills_roid(roid)
      elsif bullet.class==Cannon
        # if cannon shots keep going 
        roid.die!
        player_kills_roid(roid)
      elsif bullet.class==ShipSegment
        if roid.radius < Roid::MIN_RADIUS * 1.15 
          roid.die!
          bullet.die!
          player_kills_roid(roid)
        end
      end
    end 
  end 

  def add_roid
    @roids << Roid.new(self, @width * rand, @height * rand , nil, @level)
  end

  def player_kills_roid(roid, roid_killer=nil)
    return player_kills_alien(roid, roid_killer) if roid.class==Alien

    roid_killer ||= @ship 
    roid.play_explosion
    points=((1 / roid.radius) * 100).round(1)*10
    game.player.add_points(points.to_i)
    if roid.radius > Roid::MIN_RADIUS * 1.15 
      r=rand 
      # too many rocks were getting generated per level. 
      if r < (0.4 + @level / 22 ) 
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        # @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      elsif r < @level / 22
        # @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      else 
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      end   
    else 
      roid=RoidExploding.new(self, roid)
      @schrapnel= roid.segments + @schrapnel unless @schrapnel.size > 100 
    end 
    roid.die!
  end 

  def player_kills_alien(alien, roid_killer=nil)
    roid_killer ||= @ship 
    alien.play_explosion
    points=500
    game.player.add_points(points.to_i)
    alien=AlienExploding.new(self, alien)
    @schrapnel= alien.segments + @schrapnel unless @schrapnel.size > 100 
    alien.die!
  end 

  def freeze 
  end 

  def spawn_ship 
    @ship = Ship.new(self, @width / 2 , @height / 2)
    @ship.make_immune(3)
  end 

  def revive 
    @ttl=9999999999
    @dead=false
  end 

  def elapsed_total
    game.elapsed_total
  end

  def game_over
  end 

  def game_over?
    @game.game_over
  end 

  def do_score(display)
    display.fill_color = Color[133,130,135]
    display.text_font GAME_FONT
    display.text_size=20
    display.scale 1
    display.fill_text("Score: #{game.player.score} Lives: #{@game.player.lives} Shields: #{game.player.shields} Level #{@level}", 15, 20 )
  end 

  def add_bullet(b)
    @bullets << b
  end 

  def add_alien_bullet(b)
    @alien_bullets << b
  end 
end
