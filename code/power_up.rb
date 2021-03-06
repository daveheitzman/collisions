class PowerUp < Box
  COLOR=Color[(rand*256).to_i, (rand*256).to_i, (rand*256).to_i ]

  def initialize(scene, x = 0, y = 0)
    super 
    USER_GETS_SOUND=MutableSound['sound/coin2.ogg']
    @ttl=0
    @stl=15
    @width=31
    @height=31
    @velocity_x = 0
    @velocity_y = 0
    @p_rot = 0
    @p_rot_delta=0.04
    @text="!"
    @x = (@scene.height*0.8)*rand + @scene.height*0.1
    @y = (@scene.width*0.8)*rand + @scene.width*0.1  
  end

  def set_text(t)
    @text=t
  end 
  
  def update(elapsed)
    super
    @p_rot += (@p_rot_delta*elapsed)
    @p_rot = @p_rot % TWO_PI
  end

  def draw(d)
    d.push
    d.stroke_color = COLOR
    d.text_size = 20
    d.stroke_width = 2
    d.stroke_rectangle(@x, @y, @width, @height)
    d.stroke_text @text
    d.pop
  end

  def help(ship)
    #subclass implements 
    USER_GETS_SOUND.play
    ship.make_immune(2)
  end 

  def make_twist
    @p_rot=rand*Math::PI
    @p_rot_delta=3.94
    @p_rot_delta=0
    @twist = @width*rand + @width/2
    @twist_multi=-18
  end 

  def update_twist(elapsed)
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

end

