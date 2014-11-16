
class Player
  attr_reader :lives  , :score , :scene
  
  def initialize(scene)
    @scene=scene
    @lives=3
    @score=0
  end 
  
  def lose_life
    @lives -= 1 
  end 

  def extra_life
    @lives += 1 
  end 

end
