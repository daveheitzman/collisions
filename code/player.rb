
class Player
  attr_reader :lives  , :score 
  
  def initialize
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
