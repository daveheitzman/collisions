class Box
  COLOR = Color[201, 94, 18]
  TWO_PI=Math::PI*2

  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled , :game, :dead, :radius , :ttl

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @in_collision=false
    @width = 20
    @height = 20
    @radius=((@width**2+@height**2) ** 0.5) / 2
    @filled = rand >= 0.5 
    @velocity_x = rand*128 - 64
    @velocity_y = rand*128 - 64 
    @dead=false
    @ttl = 999999999999999
  end

  def update(game,  elapsed)
    @game ||= game
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
      @y=game.scene.height - @radius - 1
    elsif (y + @radius) > game.scene.height
      @y=@radius+1
    end

    # Horizontal wall collision
    if (x - @radius) < 0
      @x=game.scene.width - @radius - 1
    elsif (x + @radius) > game.scene.width
      @x=@radius+1
    end

  end 

  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, @height)

    if @filled
      d.fill_color = COLOR
      d.fill_rectangle(@x, @y, @width, @height)
      @collided = false
    end
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
    @in_collision = left < thing.right && right > thing.left &&
      top < thing.bottom && bottom > thing.top
  end

end
