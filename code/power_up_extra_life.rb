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
    @ship=Ship.new(scene,@x,@y)
  end

  def set_text(t)
    @text=t
  end 

  def draw(d)
    d.push
      # d.translate @x, @y
      d.stroke_color = Ship::COLOR
      d.stroke_width = 2
      d.stroke_rectangle(@x-@width*0.5, @y-@height*0.5, @width, @height)
      d.fill_color = Ship::COLOR
      @ship.draw_triangle(d,0)
    d.pop
  end

  def help(ship)
    super
    @scene.game.player.extra_life unless @dead
    @dead=true  
  end 
end

