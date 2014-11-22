class PowerUpShield < PowerUp
  # COLOR=Color[(rand*256).to_i, (rand*256).to_i, (rand*256).to_i ]
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
      # d.fill_color = FILL_COLOR
      d.translate @x, @y
      d.stroke_width = 2
      # d.stroke_color = @scene.ship.shield_color
      d.stroke_color = BOX_COLOR
      d.stroke_rectangle(-@boxw/2 , -@boxh/2, @boxw, @boxw )
      d.stroke_width = 0.8+0.4*@twist
      # puts @twist.to_s # 0-8
      d.stroke_color = Color[ (200+@twist*5).to_i, 124,124]
      d.stroke_ellipse(0,0, @width, @height)
    d.pop

    # d.stroke_color = COLOR 
    # d.text_size = 20
    # d.stroke_width = 2
    # d.stroke_rectangle(@x, @y, @width, @height)
    # d.fill_color = COLOR
    # d.fill_text @text , @x+8, @y+d.text_size 
  end

  def help(ship)
    super
    @scene.game.player.add_shield
    @dead=true 
  end 
end

