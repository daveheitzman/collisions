require 'mutable_sound'
require 'scene'
require 'box'
require 'ship'
require 'bullet'
require 'roid'
require 'ship_exploding'
require 'roid_exploding'
require 'ship_segment'
require 'level_data'
require 'player'

class CollisionsDemo < Game
  BG_COLOR = Color[211, 169, 96]
  TEXT_COLOR = Color[10, 10, 10]
  LIGHT_TEXT_COLOR = Color[90, 90, 90]

  attr_accessor :scene, :elapsed_total

  def setup
    MutableSound.un_mute!
    MutableSound.mute!
    @level = 1 
    @elapsed_total = 0
    @player = Player.new(self)
    @scene = Scene.new(self,@level)

  end
  
  def next_level
    @level+=1
    @scene = Scene.new(self,@level)
  end 

  def restart_level
    @player.lose_life
    @scene = Scene.new(self,@level)
  end 

  def update(elapsed)
    @scene.update(elapsed)
    @elapsed_total += elapsed
    if @scene.dead 
      if @scene.outcome=="died" 
        restart_level
      elsif @scene.outcome=="solved"
        next_level
      end 
      return 
    end 
    display.fill_color = BG_COLOR
    display.clear

    display.push
    offset = (display.height - @scene.height) / 2
    display.translate(offset, offset)
    @scene.draw(display)
    display.pop

    text_x = @scene.width + offset * 2
    text_y = offset + display.text_size
    line_height = display.text_size
    display.fill_color = TEXT_COLOR

    display.fill_text("fps: #{ticker.ticks_per_second}", text_x, text_y)

    display.fill_text("boxes: #{@scene.box_count}",
                      text_x, text_y + line_height * 2)
    display.fill_color = LIGHT_TEXT_COLOR
    display.fill_text("+ add, - remove",
                      text_x=text_x + 120, text_y= text_y + line_height * 2)
    display.fill_text("elapsed: #{elapsed}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("bullets: #{@scene.things.select{|i| i.is_a?(Bullet) }.size }", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("ship rot: #{@scene.ship.p_rot}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_color = TEXT_COLOR
  end
end
