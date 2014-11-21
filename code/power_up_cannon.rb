class PowerUpCannon < PowerUp
  # COLOR=Color[(rand*256).to_i, (rand*256).to_i, (rand*256).to_i ]
  COLOR=Color[144, 212, 244 ]
  FILL_COLOR=Color[124, 219, 213 ]
  FILL_COLOR=Cannon::COLOR
  puts 'power up cannon color '+COLOR.inspect

  def initialize(scene, x = 0, y = 0)
    super 
    @ttl=0
    @stl=15
    @width=10
    @height=10
    @boxh=@height+17
    @boxw=@width+17
    @velocity_x = 0
    @velocity_y = 0
    @text="C"
    @p_rot=rand*Math::PI
    @p_rot_delta=3.94
    @p_rot_delta=0
    @twist = @width*rand + @width/2
    @twist_multi=-18
  end

  def set_text(t)
    @text=t
  end 

  def update(elapsed)
    super
    @twist += elapsed*@twist_multi 
    if @twist < 0.1 
      @twist = 0.1 
      @twist_multi *= -1
    elsif @twist > @width*0.98 
      @twist = @width*0.98
      @twist_multi *= -1
    end 
    @twist = @twist % @width 
  end

  def draw(d)
    d.push
      d.stroke_color = FILL_COLOR
      d.fill_color = FILL_COLOR
      d.translate @x, @y
      d.stroke_rectangle(-@boxw/2 , -@boxh/2, @boxw, @boxw )
      d.fill_ellipse(0,0, @twist, @height)
    d.pop
  end

  def help(ship)
    super
    ship.set_bullet_type(Cannon, 1111111111) unless @dead 
    @dead=true 
  end 
end

