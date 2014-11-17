class Box
  COLOR = Color[201, 94, 18]
  TWO_PI=Math::PI*2

  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader  :scene, :dead, :radius , :ttl

  def initialize(scene, x = 0, y = 0)
    @scene=scene
    @x = x
    @y = y
    @in_collision=false
    @width = 20
    @height = 20
    @radius=((@width**2+@height**2) ** 0.5) / 2
    @velocity_x = rand*128 - 64
    @velocity_y = rand*128 - 64 
    @dead=false
    @start_immune=0
    @ttl = 999999999999999
    @end_immune = 0
  end

  def update( elapsed)
    check_wall_collision
    @x += @velocity_x * elapsed
    @y += @velocity_y * elapsed
    @ttl -= 1
    @dead=true if @ttl < 0 
    @in_collision=false
  end

  def check_wall_collision

    # Vertical wall collision
    if (y - @radius) < 0
      @y=@scene.height - @radius - 1
    elsif (y + @radius) > @scene.height
      @y=@radius+1
    end

    # Horizontal wall collision
    if (x - @radius) < 0
      @x=@scene.width - @radius - 1
    elsif (x + @radius) > @scene.width
      @x=@radius+1
    end

  end 

  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, @height)

    d.fill_color = COLOR
    d.fill_rectangle(@x, @y, @width, @height)
    @collided = false
  end

  def top
    @y
  end

  def bottom
    @y + @height
  end

  def left
    @x
  end

  def right
    @x + @width
  end

  def front
    @z
  end

  def back
    @z + @depth
  end

  def center
    [@x + @width / 2, @y + @height / 2]
  end

  def colliding?(thing)
    @in_collision = !immune? && (left < thing.right && right > thing.left &&
      top < thing.bottom && bottom > thing.top)
  end


  def make_immune(seconds)
    @end_immune=@scene.elapsed_total + seconds
  end 

  def immune?
    # true  
    @scene.elapsed_total < @end_immune
  end 

  def new_direction(radians)
    newx=Math.cos radians
    newy=Math.sin radians
    vel = (@velocity_x**2 + @velocity_y**2)**0.5
    @velocity_x=vel*newx*0.3 
    @velocity_y=vel*newy*0.3
  end 
end

