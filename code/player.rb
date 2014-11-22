
class Player
  attr_reader :lives  , :score , :scene, :shields, :bullet_type

  def initialize(scene)
    @scene=scene
    @lives=3
    @bullet_type=Bullet
    @shields=3
    @score=0
  end 

  def lose_life
    @lives -= 1 
  end 
  def extra_life
    @lives += 1 
  end 
  def add_points(p)
    @score += p
  end 
  def add_shield()
    @shields += 1
  end 
  def lose_shield
    @shields -= 1
  end 
  def set_bullet_type(bt)
    @bullet_type=bt
  end 
end
