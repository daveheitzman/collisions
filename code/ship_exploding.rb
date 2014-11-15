class ShipExploding < Ship
  COLOR = Color[133, 47, 222]
  MAX_VELOCITY=400
  SHOOT_SOUND=Sound['shoot.wav']
  THRUST_SOUND=Sound['thrust.wav']
  THRUST_SOUND_WAIT=0.7
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled, :p_rot , :game 

  def initialize(ship)
    super ship.x, ship.y
    @x = ship.x
    @y = ship.y
    @segments=[]
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