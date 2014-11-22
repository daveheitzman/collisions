class Star < Box

  def initialize(scene, x = 0, y = 0)
    super
  end 

  def draw 
  end 
  
  def colliding? 
    @in_collision = false 
  end 

end
