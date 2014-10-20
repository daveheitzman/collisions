class Box
  attr_accessor :position, :size, :velocity

  def initialize(position = V[])
    @position = position
    @size = V[16, 16]
    @velocity = V[48, 48]

    @velocity.x *= -1 if rand.round.zero?
    @velocity.y *= -1 if rand.round.zero?
  end

  def update(game, things, elapsed)
    @position += @velocity * elapsed

    # Vertical wall collision
    if y < 0
      @position.y = 0
      @velocity.y *= -1
    elsif y + height > game.scene.height
      @position.y = game.scene.height - height
      @velocity.y *= -1
    end

    # Horizontal wall collision
    if x < 0
      @position.x = 0
      @velocity.x *= -1
    elsif x + width > game.scene.width
      @position.x = game.scene.width - width
      @velocity.x *= -1
    end

    # Thing collision
    things.each do |thing|
      next if self == thing
      @collided = true if colliding?(thing)
    end
  end

  def draw(d)
    d.stroke_color = Color[201, 94, 18]
    d.stroke_width = 2
    d.stroke_rectangle(@position, @size)

    if @collided
      d.fill_color = d.stroke_color
      d.fill_rectangle(@position, @size)
      @collided = false
    end
  end

  def x
    position.x
  end

  def y
    position.y
  end

  def z
    position.z
  end

  def width
    size.x
  end

  def height
    size.y
  end

  def depth
    size.z
  end

  def top
    y
  end

  def bottom
    y + height
  end

  def left
    x
  end

  def right
    x + width
  end

  def front
    z
  end

  def back
    z + depth
  end

  def center
    position + size / 2
  end

  def colliding?(thing)
    left < thing.right && right > thing.left &&
      top < thing.bottom && bottom > thing.top
  end
end
