class Cannon < Bullet
  COLOR = Color[230, 230, 222]

  def initialize(scene, x = 0, y = 0)
    super
    @width=7
    @height=7
    @p_rot = Math::PI/2
    
    @dead=false
    @radius=4
    @stl=1.6
  end

  def update(elapsed)
    super
  end

  def draw(d)
    d.push
    d.fill_color = COLOR
    d.fill_ellipse @x, @y, 4 , 4 
    d.pop
  end

  def colliding?(thing)
    dist=( (thing.x-@x)**2 + (thing.y-@y)**2 ) ** 0.5
    @in_collision = dist < (thing.radius + @radius )*1.2
  end
end
