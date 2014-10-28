class Box
  COLOR = Color[201, 94, 18]

  attr_accessor :x, :y, :width, :height, :velocity

  def initialize(x = 0, y = 0)
    @x = x
    @y = y

    @width = 20
    @height = 20

    @velocity_x = 48
    @velocity_y = 48
    @velocity_x *= -1 if rand.round.zero?
    @velocity_y *= -1 if rand.round.zero?
  end

  def update(game, things, elapsed)
    @x += @velocity_x * elapsed
    @y += @velocity_y * elapsed

    # Vertical wall collision
    if y < 0
      @y = 0
      @velocity_y *= -1
    elsif y + height > game.scene.height
      @y = game.scene.height - height
      @velocity_y *= -1
    end

    # Horizontal wall collision
    if x < 0
      @x = 0
      @velocity_x *= -1
    elsif x + width > game.scene.width
      @x = game.scene.width - width
      @velocity_x *= -1
    end

    # Thing collision
    things.each do |thing|
      next if self == thing
      @collided = true if colliding?(thing)
    end
  end

  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, @height)

    if @collided
      d.fill_color = d.stroke_color
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
    left < thing.right && right > thing.left &&
      top < thing.bottom && bottom > thing.top
  end
end
