require 'scene'
require 'box'

class CollisionsDemo < Game
  attr_accessor :scene

  def setup
    @size = display.size
    @scene = Scene.new
  end

  def update(elapsed)
    @scene.update(self, elapsed)

    display.fill_color = Color[211, 169, 96]
    display.clear

    display.push
      offset = (display.height - @scene.height) / 2
      display.translate(V[offset, offset])
      @scene.draw(display)
    display.pop

    text_position = V[@scene.width + offset * 2, offset + display.text_size]
    line_height = display.text_size
    display.fill_color = Color[10, 10, 10]

    display.fill_text("fps: #{ticker.actual_rate}", text_position)

    display.fill_text("boxes: #{@scene.box_count}",
                      text_position + V[0, line_height * 2])
    display.fill_color = Color[90, 90, 90]
    display.fill_text("+ add, - remove",
                      text_position + V[120, line_height * 2])
    display.fill_color = Color[10, 10, 10]

    display.fill_text("dimensions: 2",
                      text_position + V[0, line_height * 4])
    display.fill_text("broad phase: quadtree",
                      text_position + V[0, line_height * 5])
    display.fill_text("narrow phase: points",
                      text_position + V[0, line_height * 6])
  end
end
