class Scene
  BORDER_COLOR = Color[10, 10, 10]
  BULLET_WAIT = 0.15
  THRUST_SOUND_WAIT = 0.5
  GAME_FONT=Font['envy_code_r.ttf']

  attr_accessor :things, :width, :height
  attr_reader :box_count, :ship, :hero, :dead, :outcome , :level , :game

  def initialize( game, level )
    @ticks=0
    @game=game
    @level=level
    @width = 700
    @height = 650
    @things = []
    @outcome="died"
    spawn_player
    (2+level).times{ add_roid }
    @bullet_off_delay = -1
    revive
  end

  def update( elapsed)
    @ttl -= 1
    @ticks += 1 
    @dead=true if @ttl < 0 
    if @level >= 0
      if @game.keyboard.pressing? :z
        if @bullet_off_delay < 0
          @things << @ship.missile
          @bullet_off_delay=BULLET_WAIT
        else 
          @bullet_off_delay -= elapsed
        end   
      end 

      @ship.thrust() if game.keyboard.pressing? :x
      @ship.thrust() if game.keyboard.pressing? :up

      if game.keyboard.pressing? :left
        # @hero.left()
        @ship.left()
      elsif game.keyboard.pressing? :right
        # @hero.right()
        @ship.right()
      end
      if game.keyboard.pressing? :space
        if @bullet_off_delay < 0
          # @things << @hero.new_bullet
          @bullet_off_delay=BULLET_WAIT
        else 
          @bullet_off_delay -= elapsed
        end   
      end
    end
    @things.each do |t|
      t.update(elapsed)
    end 
    if @level >= 0
      @ship.update( elapsed)
    end 
    things_size=@things.size
    if @level >= 0
      collide_boxes 
      if things_size > 0 && @things.empty?
        @ttl=90
        @outcome="solved"
      end 
    end 
    freeze 
  end

  def draw(display)
    @things.each do |t|
      t.draw(display)
    end 
    # @hero.draw(display)
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
    if @ticks < 100 
      display.fill_color = Color[33,33,33]
      display.text_font GAME_FONT
      display.text_size=30
      display.scale 1
      display.fill_text("Level #{@level}", width/2-50, height/2 )
    end 
    do_score display     
    display.stroke_color = BORDER_COLOR
    display.stroke_width = 3
    display.stroke_rectangle(0, 0, @width, @height)
  end

  def collide_boxes
    @things.each_with_index do |thing, i|
      next if thing.nil? 
      if thing.dead
        @things[i]=nil
      end
      b1_ind=i
      b2_ind=nil
      collided_tmp=thing.in_collision
      hit_by_bullet=false 
      
      if @ship.colliding?(thing)
        @ship = ShipExploding.new(self, @ship)  
        @ttl = 90
      end 
      
      @things.each_with_index do |thing2, i2| 
        next if thing == thing2 || thing2.nil? 
        if thing.colliding?(thing2)
          if thing.is_a?(Bullet) || thing2.is_a?(Bullet) 
            hit_by_bullet=true
            # if anything hits a bullet , bullet and thing are dead
            @things[i]=nil    
            @things[i2]=nil
            if thing.is_a?(Roid) || thing2.is_a?(Roid)

              roid=[thing,thing2].select{|t| t.is_a?(Roid)}.first
              roid.play_explosion
              points=((1 / roid.radius) * 100).round(1)*10
              game.player.add_points(points.to_i)
              if roid.radius > Roid::MIN_RADIUS * 1.05 
                @things << Roid.new(self, roid.x, roid.y, roid.radius*0.7, @level )
                @things << Roid.new(self, roid.x, roid.y, roid.radius*0.6, @level )
                @things << Roid.new(self, roid.x, roid.y, roid.radius*0.5, @level )
              else 
                roid=RoidExploding.new(self, roid)
                @things << roid 
              end 
            end 
            next 
          end 
          thing.in_collision = true 
          b2_ind=i2
          break
        end 
        thing.in_collision=false
      end 
      
      if !hit_by_bullet && !collided_tmp && thing.in_collision
        #collision starting
      elsif collided_tmp && !thing.in_collision 
        #collision ending
      end 
    end
    @things.compact!
  end 

  def add_roid
    things << Roid.new(self, @width * rand, @height * rand , nil, @level)
  end

  def freeze 
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
