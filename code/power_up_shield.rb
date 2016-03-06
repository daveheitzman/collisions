class PowerUpShield < PowerUp
  COLOR=Color[155,155,155]
  BOX_COLOR=Color[220,100,100]

  def initialize(scene, x = 0, y = 0)
    super 
    @ttl=0
    @stl=15
    @width=9
    @height=9

    @boxh=@height+17
    @boxw=@width+17

    @velocity_x = 0
    @velocity_y = 0
    @text="S"
    make_twist
  end

  def set_text(t)
    @text=t
  end 
  
  def update(elapsed)
    update_twist(elapsed)
  end

  def draw(d)
    d.push
      d.translate @x, @y
      d.stroke_width = 2
      d.stroke_color = BOX_COLOR
      d.stroke_rectangle(-@boxw/2 , -@boxh/2, @boxw, @boxw )
      d.stroke_width = 0.8+0.4*@twist
      d.stroke_color = Color[ (200+@twist*5).to_i, 124,124]
      d.stroke_ellipse(0,0, @width, @height)
    d.pop
  end

  def help(ship)
    super
    @scene.game.player.add_shield
    @dead=true 
  end 

end

