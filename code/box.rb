class Box
  COLOR = Color[201, 94, 18]

  attr_accessor :x, :y, :width, :height, :velocity, :in_collision
  attr_reader :filled , :game

  def initialize(x = 0, y = 0)
    @x = x
    @y = y
    @in_collision=false
    @width = 20
    @height = 20
    @filled = rand >= 0.5 
    @velocity_x = rand*128 - 64
    @velocity_y = rand*128 - 64 
    # @velocity_x *= -1 if rand.round.zero?
    # @velocity_y *= -1 if rand.round.zero?
  end

  def update(game,  elapsed)
    @game ||= game
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
    # %x{
    #   for (var i = 0; i < things.length; i++) {
    #     if (things[i] == this) continue;
    #     if (this['$colliding?'](things[i])) this.collided = true;
    #   }
    # }
    # return

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
