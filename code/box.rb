class Box
  attr_accessor :position, :size, :velocity

  def initialize(position = V[])
    @position = position
    @size = V[16, 16]
    @velocity = V[48, 48]
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
      return if self == thing

      # Sides
      if colliding_left? thing
        @position.x = thing.x + thing.width
        @velocity.x *= -1
        thing.velocity.x *= -1
      elsif colliding_right? thing
        @position.x = thing.x - width
        @velocity.x *= -1
        thing.velocity.x *= -1
      end

      # Bottom
      if colliding_bottom? thing
        @position.y = thing.y - height
        @velocity.y *= -1
        thing.velocity.y *= -1

      # Top
      elsif colliding_top? thing
        @position.y = thing.y + thing.height
        @velocity.y *= -1
        thing.velocity.y *= -1
      end
    end
  end

  def draw(d)
    d.stroke_color = Color[201, 94, 18]
    d.stroke_width = 2
    d.stroke_rectangle(@position, @size)
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

  private

  def point_in_bounds?(point, rect_pos, rect_size)
    point.x > rect_pos.x && point.x <= rect_pos.x + rect_size.x &&
    point.y > rect_pos.y && point.y <= rect_pos.y + rect_size.y
  end

  def colliding_top?(thing)
    point_in_bounds?(@position + V[width / 2, 0],
                     thing.position, thing.size)
  end

  def colliding_bottom?(thing)
    point_in_bounds?(@position + V[width / 2, height],
                     thing.position, thing.size)
  end

  def colliding_left?(thing)
    point_in_bounds?(@position + V[0, height / 2],
                     thing.position, thing.size)
  end

  def colliding_right?(thing)
    point_in_bounds?(@position + V[width, height / 2],
                     thing.position, thing.size)
  end
end
