class ShipExploding < Ship
  COLOR = Color[133, 47, 222]
  MAX_VELOCITY=400
  EXPLOSION_SOUND=MutableSound['ship_explosion.wav']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :p_rot 

  def initialize(scene, ship)
    super scene, ship.x, ship.y
    @x = ship.x
    @y = ship.y
    @segments=[]
    if ship.is_a?(Ship) 
      EXPLOSION_SOUND.play
    end 
    (7+rand*6).to_i.times do |t|
      @segments << ShipSegment.new(@scene, ship)
    end 

    @ttl=90
  end

  def draw(d)
    if !@dead 
      @segments.each {|s| s.draw d}
    end 
  end

  def update(elapsed)
    super
    if !@dead 
      @segments.each {|s| s.update(elapsed) }
    end 
  end
  
  def colliding?(thing)
    @in_collision = false
  end

end