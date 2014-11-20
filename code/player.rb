
class Player
  attr_reader :lives  , :score , :scene, :shields
  
  def initialize(scene)
    @scene=scene
    @lives=99
    @shields=93
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
end
