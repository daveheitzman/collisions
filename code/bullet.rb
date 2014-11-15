class Bullet < Box
  COLOR = Color[55, 144, 238]

  attr_accessor :x, :y, :width, :height, :velocity_x, :velocity_y, :in_collision, :dead
  attr_reader :filled 

  def initialize(x = 0, y = 0)
    super
    @dead=false
    @width=4
    @height=4
    @x = x
    @y = y
    @in_collision=false
    @radius=25
    @filled = true
    @velocity_x = 0
    @velocity_y = -435
  end

  def update(game,  elapsed)
    @x += @velocity_x * elapsed
    @y += @velocity_y * elapsed

    # Vertical wall collision
    if y < 0 || y + height > game.scene.height
      @dead=true
    end

    # Horizontal wall collision
    if x < 0 || x + width > game.scene.width
      @dead=true
    end

  end

  def draw(d)
    @collided = false
    d.push
    d.stroke_color = COLOR
    d.stroke_width = 2

    d.fill_color = COLOR
    d.fill_rectangle(@x, @y, @width, @height)
    @collided = false
    d.pop

  end


    
  # def left
  #   @velocity_x -= 11.5
  # end 

  # def right 
  #   @velocity_x += 11.5
  # end  
end
