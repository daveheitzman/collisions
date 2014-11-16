class MarqueeScene < Scene
  def initialize 
    super
    @ttl=90 # about 3 seconds 
  end 
  def display
    super 
    display.fill_color = Color[33,33,33]
    display.text_font GAME_FONT
    display.text_size=30
    display.scale 1
    display.fill_text("Level #{@level}", width/2-50, height/2 )
  end 
end
