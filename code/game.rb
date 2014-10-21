require 'scene'
require 'box'

class CollisionsDemo < Game
  BG_COLOR = Color[211, 169, 96]
  TEXT_COLOR = Color[10, 10, 10]
  LIGHT_TEXT_COLOR = Color[90, 90, 90]

  attr_accessor :scene

  def setup
    @scene = Scene.new
  end

  def update(elapsed)
    @scene.update(self, elapsed)

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

    display.fill_text("fps: #{ticker.actual_rate}", text_x, text_y)

    display.fill_text("boxes: #{@scene.box_count}",
                      text_x, text_y + line_height * 2)
    display.fill_color = LIGHT_TEXT_COLOR
    display.fill_text("+ add, - remove",
                      text_x + 120, text_y + line_height * 2)
    display.fill_color = TEXT_COLOR
  end
end
