class RoidExploding < Ship
  COLOR = Roid::COLOR
  MAX_VELOCITY=400
  EXPLOSION_SOUND=MutableSound['ship_explosion.wav']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :p_rot , :game 

  def initialize(scene, roid)
    super scene, roid.x, roid.y
    @x = roid.x
    @y = roid.y
    @segments=[]
    (4+rand*6).to_i.times do |t|
      @segments << ShipSegment.new(scene, roid)
    end 
    @ttl=60
  end

  def draw(d)
    if !@dead 
      @segments.each {|s| s.draw d}
    end 
  end

  def update(elapsed)
    super
    if !@dead 
      @segments.each { |s| s.update(elapsed) }
    else 
      @segments=[]
    end 
  end
  
  def colliding?(thing)
    @in_collision = false
  end

end