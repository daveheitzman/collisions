class Cannon < Bullet
  COLOR = Color[250, 199, 144]

  def initialize(scene, x = 0, y = 0)
    super
    @width=7
    @height=7
    @p_rot = Math::PI/2
    @dead=false
    @radius=18
    @stl=1.6
  end

  def update(elapsed)
    super
    # @x += @velocity_x * elapsed
    # @y += @velocity_y * elapsed
    # @dead=false 

    # # Vertical wall collision
    # if y < 0 || y + height > @scene.height
    #   @dead=true
    # end

    # # Horizontal wall collision
    # if x < 0 || x + width > @scene.width
    #   @dead=true
    # end
  end

  def draw(d)
    d.push
    d.fill_color = COLOR
    d.fill_rectangle(@x, @y, @width, @height)
    d.pop
  end

  def colliding?(thing)
    dist=( (thing.x-@x)**2 + (thing.y-@y)**2 ) ** 0.5
    @in_collision = dist < (thing.radius + @radius )
  end
end
