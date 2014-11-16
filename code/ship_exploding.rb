class ShipExploding < Ship
  COLOR = Color[133, 47, 222]
  MAX_VELOCITY=400
  EXPLOSION_SOUND=Sound['ship_explosion.wav']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled, :p_rot , :game 

  def initialize(ship)
    super ship.x, ship.y
    @x = ship.x
    @y = ship.y
    @segments=[]
    EXPLOSION_SOUND.play
    (7+rand*6).to_i.times do |t|
      @segments << ShipSegment.new(ship)
    end 

    @ttl=1
  end

  def draw(d)
    if !@dead 
      @segments.each {|s| s.draw d}
    end 
  end

  def update(game, elapsed)
    super
    if !@dead 
      @segments.each {|s| s.update(game,elapsed) }
    end 
  end
  
  def colliding?(thing)
    @in_collision = false
  end

end