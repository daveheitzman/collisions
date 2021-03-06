class Bullet < Box
  COLOR = Color[255, 255, 255]
  SHOOT_SOUND = MutableSound['sound/laser02q.ogg']

  attr_accessor :x, :y, :width, :height, :velocity_x, :velocity_y, :in_collision
  attr_reader :filled, :bullet_off_delay 

  def initialize(scene, x = 0, y = 0, ship=nil)
    super
    shoot_sound
    @bullet_off_delay = 0.44 - 0.01 * @scene.level

    @dead=false
    @width=4
    @height=4
    @x = x
    @y = y
    @in_collision=false
    @radius=14
    @filled = true
    if ship.is_a?(Alien)
      @dir = TWO_PI * rand  
      @speed=ship.speed + 100
    elsif ship.is_a?(Ship)
      @dir = ship.p_rot 
      @speed=ship.speed + 370
    end 
    @ttl=0
    @stl=1.2
  end

  def shoot_sound
    SHOOT_SOUND.play
  end 
  
  def update(elapsed)
    super 

    # # Vertical wall collision
    if y < 0
      @y = y + @scene.height
    elsif y > @scene.height
      @y = y - @scene.height
    end

    if x < 0
      @x = x + @scene.width
    elsif x > @scene.width
      @x = x - @scene.width
    end
  end

  def draw(d)
    @collided = false
    d.push
    d.stroke_color = COLOR
    d.stroke_width = 2

    d.fill_color = COLOR
    d.fill_rectangle(@x, @y, @width, @height)
    @collided = false
    d.pop
  end

  def colliding?(thing)
    dist=( (thing.x-@x)**2 + (thing.y-@y)**2 ) ** 0.5
    @in_collision = dist < thing.radius 
  end

end
