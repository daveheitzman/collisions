class AlienExploding < RoidExploding 
  COLOR = Alien::COLOR
  MAX_VELOCITY=400
  EXPLOSION_SOUND=MutableSound['sound/alien_explosion.ogg']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :p_rot , :game , :segments
  def initialize
    super 
    EXPLOSION_SOUND.play
  end 
end