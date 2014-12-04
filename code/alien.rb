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
      @dir = 0.5*Math::PI 
    else
      @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
      @x=@scene.width - 10
      @dir = 1.5*Math::PI 
    end 
    @stl=12
    @ttl=0
    @speed=45
    @height=40
    @width=40
    @radius = 20
    @shoot_delay=1.3 - @scene.level*0.05
    @shoot_delay_timer = 0
    FLY_SOUND.play.repeat
  end 

  def draw(d)
    return if @dead 
    bulb_x=19
    bulb_y=12
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
      @shoot_delay_timer = @shoot_delay * (0.4 * rand + 0.8) 
      new_bullet
    end 
  end 

  def new_bullet
    if !@dead 
      SHOOT_SOUND.play
      b=Bullet.new @scene, @x+(@width/2)+5, @y, self
      @scene.add_alien_bullet b 
    end   
  end 

  def immune? 
    false
  end 
  
  def colliding?(thing)
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

