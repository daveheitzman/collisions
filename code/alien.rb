class Alien < Ship
  COLOR = Color[244, 22, 18]
  # SHOOT_SOUND = Sound['.wav']
  # FLY_SOUND = Sound['.wav']
  
  def initialize(scene, x = 0, y = 0)
    super 
    @y = @height*0.3
    @y = 200
    @y = (rand * (@scene.height * 0.4) + @scene.height*0.3).to_i
    @height=40
    @width=40
    @shoot_delay=0.9 - @scene.level*0.05
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

  def update(elapsed)
    super 
    if rand < 0.03 
      new_bullet
    end 
  end 

  def new_bullet
    # SHOOT_SOUND.play
    if !@dead 
      # SHOOT_SOUND.play
      rot = rand * TWO_PI
      vel=70+@scene.level*8
      b=Bullet.new @scene, @x+(@width/2)-5, @y

      b.velocity_x = (Math.cos(rot-Math::PI/2) * vel) + @velocity_x
      b.velocity_y = (Math.sin(rot-Math::PI/2) * vel) + @velocity_y 
      @scene.add_alien_bullet b 
    end   
  end 

end

