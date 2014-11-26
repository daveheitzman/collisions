class AlienExploding < RoidExploding 
  COLOR = Alien::COLOR
  MAX_VELOCITY=400
  EXPLOSION_SOUND=MutableSound['ship_explosion.wav']
  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :p_rot , :game , :segments



end