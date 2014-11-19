class PowerUpExtraLife < PowerUp
  COLOR=Color[(rand*256).to_i, (rand*256).to_i, (rand*256).to_i ]

  def initialize(scene, x = 0, y = 0)
    super 
    @ttl=0
    @stl=15
    @width=31
    @height=31
    @velocity_x = 0
    @velocity_y = 0
    @text="P"
  end

  def set_text(t)
    @text=t
  end 

  def draw(d)
    d.stroke_color = COLOR
    d.text_size = 20
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, @height)
    d.fill_color = COLOR
    d.fill_text @text , @x+8, @y+d.text_size 
    @collided = false
  end

  def help(ship)
    super
    @scene.game.player.extra_life unless @dead
    @dead=true  
  end 
end

