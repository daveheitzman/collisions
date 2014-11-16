class RoidExploding < Ship
  COLOR = Roid::COLOR
  MAX_VELOCITY=400
  EXPLOSION_SOUND=Sound['ship_explosion.wav']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled, :p_rot , :game 

  def initialize(roid)
    super roid.x, roid.y
    @x = roid.x
    @y = roid.y
    @segments=[]
    (7+rand*6).to_i.times do |t|
      @segments << ShipSegment.new(roid)
    end 
    @ttl=90
  end

  def draw(d)
    if !@dead 
      @segments.each {|s| s.draw d}
    end 
  end

  def update(game, elapsed)
    super
    if !@dead 
      @segments.each { |s| s.update(game,elapsed) }
    else 
      @segments=[]
    end 
  end
  
  def colliding?(thing)
    @in_collision = false
  end

end