class Alien < Ship
  COLOR = Color[244, 22, 18]
  
  def initialize(scene, x = 0, y = 0)
    super 
    @y = @height*0.3
    @y = 200
    @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
    @height=40
    @width=40
    @velocity_y = 0
    @velocity_x = 80 + @scene.level*15
  end 

  def draw(d)
    d.push
      d.stroke_color = COLOR
      d.fill_color = COLOR
      d.stroke_width = 2

      d.translate x, y
      d.rotate p_rot

      d.begin_shape
      d.move_to 0,0
      d.move_to 0,-(@height/2)
      d.line_to @width/2,(@height/2)
      d.line_to -(@width/2),(@height/2)
      d.line_to 0,-(@height/2)
      d.end_shape
      d.stroke_shape
      # d.fill_shape

    d.pop

  end 

end

