require 'mutable_sound'
require 'scene'
require 'marquee_scene'
require 'box'
require 'bullet'
require 'cannon'
require 'ship'
require 'roid'
require 'ship_exploding'
require 'roid_exploding'
require 'ship_segment'
require 'level_data'
require 'player'
require 'power_up'
require 'extra_life'
require 'power_up_cannon'
require 'power_up_shield'

class CollisionsDemo < Game
  BG_COLOR = Color[211, 169, 96]
  TEXT_COLOR = Color[10, 10, 10]
  LIGHT_TEXT_COLOR = Color[90, 90, 90]
  attr_accessor :scene, :elapsed_total
  attr_reader :player, :game_over 

  def setup
    MutableSound.un_mute!
    MutableSound.mute!
    @level = 0 
    @elapsed_total = 0
    @pause_again = 0
    @player = Player.new(self)
    @game_over=false 
    @paused=false
    next_level
  end
  
  def next_level
    @level+=1
    puts 'next_level '+@level.to_s
    @scene = Scene.new(self,@level)
    @scene.ship.make_immune(3)
  end 

  def restart_level
    puts 'restart_level'
    if @player.lose_life > 0 
      @scene.spawn_player
      @scene.revive
      @scene.ship.make_immune(3)
    else 
      @scene.revive
      @scene.game_over
    end 
  end 

  def pause 
    if elapsed_total > @pause_again
      @pause_again = elapsed_total + 0.2
      @paused = !@paused 
    else 
      @paused
    end 
  end 
  
  def update(elapsed)
    if keyboard.pressing? :p
      pause
      # sleep 0.3
    end 
    @elapsed_total += elapsed
    return if @paused

    @scene.update(elapsed)
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
    display.fill_text("bullets: #{@scene.bullets.select{|i| i.is_a?(Bullet) }.size }", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("roids: #{@scene.roids.select{|i| i.is_a?(Roid) }.size }", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("ship rot: #{@scene.ship.p_rot}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("lives: #{@player.lives.to_s}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("controls: z: shoot, x: shield , ctrl-r: restart, l/r arrows, up: thrust, p: pause ", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_color = TEXT_COLOR
  end
end
