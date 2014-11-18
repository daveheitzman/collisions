class PowerUp < Box
  def initialize(scene, x = 0, y = 0)
    super 
    @ttl=15_000
    @width=100
    @height=55
    @velocity_x = 0
    @velocity_y = 0
  end

  def set_text(t)
    @text=t
  end 

  def draw(d)
    d.stroke_color = COLOR
    d.text_size = 20
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, d.text_size + 5)
    d.fill_color = COLOR
    d.fill_text @text , @x+8, @y+d.text_size 
    @collided = false
  end
end

