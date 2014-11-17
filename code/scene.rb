class Scene
  BORDER_COLOR = Color[10, 10, 10]
  BULLET_WAIT = 0.25
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
    @outcome="died"
    spawn_player
    (2+level).times{ add_roid }
# puts @roids.size.to_s 
    @bullet_off_delay = -1
    revive
  end

  def update( elapsed)
# puts 'scene update'

    @ttl -= 1
# puts @ttl.to_s
    @ticks += 1 
    @dead=true if @ttl < 0 
    if @level >= 0
      if @game.keyboard.pressing? :z
        if @bullet_off_delay < 0
          @bullets << @ship.missile
          @bullet_off_delay=BULLET_WAIT
        else 
          @bullet_off_delay -= elapsed
        end   
      end 

      @ship.thrust() if game.keyboard.pressing? :x
      @ship.thrust() if game.keyboard.pressing? :up

      if game.keyboard.pressing? :left
        @ship.left()
      elsif game.keyboard.pressing? :right
        @ship.right()
      end
      if game.keyboard.pressing? :space
        if @bullet_off_delay < 0
          @bullet_off_delay=BULLET_WAIT
        else 
          @bullet_off_delay -= elapsed
        end   
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
# puts "roids_size " + roids_size.to_s
    if  @level >= 0
      collide_boxes 
# puts "@roids.size " + @roids.size.to_s
      if roids_size > 0 && @roids.empty?
        @ttl=90
        @outcome="solved"
      end 
    end 
    freeze 
  end

  def draw(display)
# puts 'scene draw'
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
    do_score( display )     
    display.stroke_color = BORDER_COLOR
    display.stroke_width = 3
    display.stroke_rectangle(0, 0, @width, @height)
  end

  def collide_boxes
    @roids.each_with_index do |roid, i|
      next if roid.nil? 
      if roid.is_a?(RoidExploding)
        @roids[i]=nil if roid.dead
        roid=nil
        next
      end  
      if roid.dead
        @roids[i]=nil
      end
      
      if @ship.colliding?(roid)
        @ship = ShipExploding.new(self, @ship)  
        @outcome='died'
        @ttl = 90 # the scene must end when the player dies 
      end 

      @bullets.each_with_index do |bullet, bi| 
        next if bullet.nil? 
        if bullet.colliding?(roid)
          if bullet.is_a?(Bullet)
            @roids[i]=nil
          elsif bullet.is_a?(Cannon)
            @roids[i]=nil
          end
          # if anything hits a bullet , bullet and thing are dead
          roid.play_explosion
          points=((1 / roid.radius) * 100).round(1)*10
          game.player.add_points(points.to_i)
          if roid.radius > Roid::MIN_RADIUS * 1.15 
            r=rand 
            # too many rocks were getting generated per level. 
            if r < @level / 22
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
            elsif r < (0.4 + @level / 22 ) 
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
            else 
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
              @roids << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
            end   
          else 
            roid=RoidExploding.new(self, roid)
            # @roids << roid
            @schrapnel= roid.segments + @schrapnel 
          end 
        end 
        if bullet.dead 
          @bullets[bi]=nil
        end 
      end 
    end
    @roids.compact!
    # @schrapnel.compact!
    @schrapnel=@schrapnel.select{|s| !s.dead }
    @bullets.compact!
  end 

  def add_roid
    @roids << Roid.new(self, @width * rand, @height * rand , nil, @level)
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
    display.fill_text("Score: #{game.player.score} Lives: #{lives}  Level #{@level}", 15, 20 )
  end 
end
