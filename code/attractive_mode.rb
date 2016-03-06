class AttractiveMode 
  
  def initialize game
    run game
  end
  
  def update elapsed 
    true
  end 

  def run game
    MutableSound.mute!
      
    MutableSound.un_mute!
  end
end
