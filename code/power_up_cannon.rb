class PowerUpCannon < PowerUp
  # COLOR=Color[(rand*256).to_i, (rand*256).to_i, (rand*256).to_i ]
  COLOR=Color[144, 212, 244 ]
  FILL_COLOR=Color[124, 219, 213 ]
  FILL_COLOR=Cannon::COLOR
  puts 'power up cannon color '+COLOR.inspect

  def initialize(scene, x = 0, y = 0)
    super 
    @ttl=0
    @stl=15
    @width=12
    @height=12
    @velocity_x = 0
    @velocity_y = 0
    @text="C"
    @p_rot=rand*Math::PI
    @p_rot_delta=3.94
  end

  def set_text(t)
    @text=t
  end 

  def draw(d)
    d.push
      d.stroke_color = FILL_COLOR
      d.fill_color = FILL_COLOR
      d.translate @x, @y
      d.stroke_ellipse(0,0, @width+5, @height+5)
    d.pop

    d.push
      # d.translate @x-0.5*@width, @y-0.5*@height 
      d.stroke_width = 2
      d.translate @x, @y
      d.rotate @p_rot 
      # d.move_to @x,@y 
      d.fill_rectangle(-0.5*@width, -0.5*@height, @width, @height)
    d.pop
    # d.fill_text @text , @x+8, @y+d.text_size 
  end

  def help(ship)
    super
    ship.set_bullet(:cannon, 1111111111) unless @dead 
    @dead=true 
  end 
end

