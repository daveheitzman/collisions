class Roid<Box
  COLOR = Color[201, 94, 18]
  SIZE_RANGE=25..50
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
    @points = []
    @p_rot=0
    @p_rot_delta=rand * 0.01
    @radius = SIZE_RANGE.to_a.sample

    ang=0
    while ang < TWO_PI
      prev_ang=ang
      ang+= rand*(TWO_PI/8) + TWO_PI/16
      point=[@radius * Math.cos(ang ),
                      @radius * Math.sin(ang )]
      @points << point
    end 
  end

  def update(game,  elapsed)
    @game ||= game
    @x += @velocity_x * elapsed
    @y += @velocity_y * elapsed
    @p_rot += @p_rot_delta
    @p_rot = @p_rot % TWO_PI
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
    d.push
      d.translate @x,@y
      d.rotate @p_rot
      d.begin_shape
      d.move_to @points[0].first,@points[0].last
      @points.each do |p|
        d.line_to p.first, p.last
      end 
      d.line_to @points[0].first,@points[0].last
      d.move_to @x,@y
      d.stroke_shape
      d.end_shape
    d.pop
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
