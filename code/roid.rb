class Roid < Box
  COLOR = Color[201, 94, 18]
  SIZE_RANGE=19..60
  MIN_RADIUS=10
  EXPLOSION_SOUND_01=Sound['rock01.wav']
  EXPLOSION_SOUND_02=Sound['rock02.wav']
  EXPLOSION_SOUND_03=Sound['rock03.wav']
  EXPLOSION_SOUNDS = [ EXPLOSION_SOUND_01, EXPLOSION_SOUND_02, EXPLOSION_SOUND_03 ]

  attr_accessor :x, :y, :width, :height, :velocity, :velocity_x, :velocity_y, :in_collision
  attr_reader :filled , :game, :radius

  def initialize(x=0 , y=0 , rad=nil , level=nil )
    @x = x
    @y = y
    @level = level || 1
    @in_collision=false
    @filled = rand >= 0.5 
    @velocity_x = rand*128 - 64
    @velocity_y = rand*128 - 64 
    @points = []
    @p_rot=0
    @p_rot_delta=rand * 0.01
    @radius = rad || SIZE_RANGE.to_a.sample
    @width = @height = @radius * 2 

    ang=0
    while ang < TWO_PI
      prev_ang=ang
      ang+=rand*(TWO_PI/8) + TWO_PI/16
      ang = [ang,TWO_PI].min
      rad=
      if rand < 0.2 
        ( @radius/2 ) + @radius*rand
      else 
        @radius 
      end 
      point=[rad * Math.cos(ang ),
            rad * Math.sin(ang )]
      @points << point
    end 
    @ttl=99999999999999999
  end
  def update(game, elapsed)
    @scene||=game.scene
    @ttl -= 1 
    @dead = true if @ttl < 0
    @game ||= game
    @x += @velocity_x * elapsed
    @y += @velocity_y * elapsed
    @p_rot += @p_rot_delta
    @p_rot = @p_rot % TWO_PI
    check_wall_collision
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

  def play_explosion
    EXPLOSION_SOUNDS.sample.play
  end 

  def colliding?(thing)
    @in_collision = left < thing.right && right > thing.left &&
      top < thing.bottom && bottom > thing.top
  end
end
