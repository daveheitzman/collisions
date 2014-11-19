class Scene
  BORDER_COLOR = Color[10, 10, 10]
  THRUST_SOUND_WAIT = 0.5
  GAME_FONT=Font['envy_code_r.ttf']

  attr_accessor  :width, :height
  attr_reader :box_count, :ship, :hero, :dead, :outcome , :level , :game, :bullets, :roids

  def initialize( game, level )
    @ticks=0
    @game=game
    @level=level
    @width = 700
    @height = 650
    @roids = []
    @bullets = []
    @schrapnel = []
    pu=PowerUp.new(self,100,200)
    pu.set_text("+")

    @power_ups = [pu]
    @outcome="died"
    @power_up_multiplier = ( 1 / (@level ** 0.5 ) ) * 0.02
    spawn_player
    (2+level).times{ add_roid }
    @bullet_off_delay = -1
    revive
  end

  def update( elapsed )
    @ttl -= 1
    @ticks += 1 
    @dead=true if @ttl < 0 
    if @level >= 0
      if @game.keyboard.released? :z
        @ship.trigger_released()        
      end 

      if @game.keyboard.pressing? :z
        @ship.missile()        
      end 

      @ship.thrust() if game.keyboard.pressing? :up
      @ship.shield() if game.keyboard.pressing?( :x ) && game.player.shields > 0

      if game.keyboard.pressing? :left
        @ship.left()
      elsif game.keyboard.pressing? :right
        @ship.right()
      end
    end
    [@roids,[@ship],@bullets, @schrapnel ].each do |a|
      a.each  do |t|
        t.update(elapsed)
      end 
    end 


    if @level >= 0
      @ship.update( elapsed)
    end 

    roids_size=@roids.size
    if  @level >= 0
      collide_boxes 
      if roids_size > 0 && @roids.empty?
        @ttl=90
        @outcome="solved"
      end 
    end 
      
    if rand < elapsed * @power_up_multiplier
      @power_ups << [PowerUpExtraLife, PowerUpShield, PowerUpCannon].sample.new(self, (height-60)*rand + 30, (width-60)*rand+30 )
    end  

    @power_ups.each do |power_up|
      # next if power_up.dead || power_up.nil?
      power_up.update(elapsed)
      power_up.help(@ship) if @ship.colliding?(power_up) 
    end 

    @power_ups.select!{ |p| p && !p.dead }
    @roids.select!{ |s| s && !s.dead }
    @schrapnel.select!{ |s| s && !s.dead }
    @bullets.select!{ |s| s && !s.dead }

    freeze 
  end

  def draw(display)
    [@roids,[@ship],@bullets, @schrapnel ].each do |a|
      a.each  do |t|
        t.draw(display)
      end 
    end 
    if @level >= 0 
      @ship.draw(display)
    end 
    if @level < 0 
      display.fill_color = Color[33,33,33]
      display.text_font GAME_FONT
      display.text_size=30
      display.scale 1
      display.fill_text("Game Over", width/2-50, height/2 )
    end 
    #show level banner at start of scene
    if @ticks < 100 
      display.fill_color = Color[33,33,33]
      display.text_font GAME_FONT
      display.text_size=30
      display.scale 1
      display.fill_text("Level #{@level}", width/2-50, height/2 )
    end 
    @power_ups.each do |pu|
      pu.draw(display)
    end 

    do_score( display )     
    display.stroke_color = BORDER_COLOR
    display.stroke_width = 3
    display.stroke_rectangle(0, 0, @width, @height)
  end

  def collide_boxes
    @roids.each_with_index do |roid, i|
      next if roid.nil? 

      if roid.dead
        @roids[i]=nil
        next
      end
      if @ship.shield_active? && !@ship.immune? 
        dist=( (roid.x-@ship.x)**2 + (roid.y-@ship.y)**2 ) ** 0.5
        if dist < (roid.radius + @ship.shield_radius )
          @ship.make_immune(0.25)
          ang=Math.atan( (@ship.x-roid.x)/(0.00001+@ship.y-roid.y) )
          dot=Math.atan( (@ship.x)/(0.00001+@ship.y) )
          puts ang.to_s + "," + dot.to_s
          avg = ( ang + dot )/2
          @ship.new_direction(avg)
          # @ship.slower 0.6
          @roids[i]=nil
          player_kills_roid(roid)
        end 
      elsif @ship.colliding?(roid)
        @ship = ShipExploding.new(self, @ship)  
        @outcome='died'
        @ttl = 90 # the scene must end when the player dies 
      end 

      @bullets.each_with_index do |bullet, bi| 
        next if bullet.nil? 
        if bullet.colliding?(roid)
          if bullet.is_a?(Bullet)
            # if anything hits a bullet , bullet and thing are dead
            @roids[i]=nil
            @bullets[bi]=nil
          elsif bullet.is_a?(Cannon)
            # if cannon shots keep going 
            @roids[i]=nil
          end
          player_kills_roid(roid)
        end 
        if bullet.dead 
          @bullets[bi]=nil
        end 
      end 
    end

  end 

  def add_roid
    @roids << Roid.new(self, @width * rand, @height * rand , nil, @level)
  end

  def player_kills_roid(roid)
    roid.play_explosion
    points=((1 / roid.radius) * 100).round(1)*10
    game.player.add_points(points.to_i)
    if roid.radius > Roid::MIN_RADIUS * 1.15 
      r=rand 
      # too many rocks were getting generated per level. 
      if r < @level / 22
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        # @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      elsif r < (0.4 + @level / 22 ) 
        # @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      else 
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
        @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
      end   
    else 
      roid=RoidExploding.new(self, roid)
      @schrapnel= roid.segments + @schrapnel 
    end 
  end 

  def freeze 
  end 

  def spawn_player 
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
    @level=-1
  end 

  def do_score(display)
    display.fill_color = Color[33,33,33]
    display.text_font GAME_FONT
    display.text_size=20
    display.scale 1
    lives = (1..(game.player.lives-1)).map{|_| "@" }.join("")
    display.fill_text("Score: #{game.player.score} Lives: #{lives} Shields: #{game.player.shields} Level #{@level}", 15, 20 )
  end 

  def add_bullet(b)
    @bullets << b
  end 
end
