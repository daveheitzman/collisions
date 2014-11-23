class Alien < Ship
  COLOR = Color[244, 22, 18]
  
  def initialize(scene, x = 0, y = 0)
    super 
    @y = @height*0.3
    @y = 200
    @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
    @velocity_y = 0
    @velocity_x = 80 + @scene.level*15
  end 

end

