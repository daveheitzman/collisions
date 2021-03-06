module Utils ; end ;
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
require 'power_up_extra_life'
require 'power_up_cannon'
require 'power_up_shield'
require 'alien'
require 'alien_exploding'
require 'util'
require 'attractive_mode'

class MeteorMadness < Game
  BG_COLOR = Color[86,133,106]
  TEXT_COLOR = Color[10, 10, 10]
  LIGHT_TEXT_COLOR = Color[90, 90, 90]
  TEXT_FONT=Font['font/Guseul.ttf']
  attr_accessor :scene, :elapsed_total
  attr_reader :player, :game_over , :game_speed

  def setup
    MutableSound.mute!
    MutableSound.un_mute!
    @level = 0 
    @elapsed_total = 0
    @pause_again = 0
    @player = Player.new(self)
    @game_over=false 
    @paused=false
    @game_speed=1
    # @attractive_mode=AttractiveMode.new(self) 
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
      @scene.spawn_ship
      @player.set_bullet_type Bullet
      @scene.ship.make_immune(3)
      @scene.revive
    else 
      @scene.revive
      @game_over=true 
      @scene.game_over
    end 
  end 

  def pause 
    if elapsed_total > @pause_again
      @pause_again = elapsed_total + 0.2
      @paused = !@paused 
      if @paused 
        MutableSound.mute!
      else 
        MutableSound.un_mute!
      end
    end 
    @paused
  end 
  
  def update(elapsed)
    if keyboard.pressing? :p
      pause
    end 
    @elapsed_total += elapsed
    return if @paused
    # @attractive_mode.update(self) # do nothing if no user input on attractive mode 

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
    display.fill_color = TEXT_COLOR
    text_x=0
    text_y=950
    text_x = 250
    text_y = text_y + display.text_size - 150
    line_height = display.text_size
    display.fill_text("controls: z: shoot, x: shield , ctrl-r: restart, l/r arrows, up: thrust, p: pause ", text_x=text_x, text_y= text_y + line_height * 2 )
  end

  def stats
    return true 
    display.text_font=TEXT_FONT
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
    display.fill_text("ship dir: #{@scene.ship.dir}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("lives: #{@player.lives.to_s}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_text("ship: vel_x/vel_y #{@scene.ship.velocity_x},#{@scene.ship.velocity_y}", text_x=text_x, text_y= text_y + line_height * 2 )
    display.fill_color = TEXT_COLOR
  end 
end
