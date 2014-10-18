require 'quadtree'

class Scene
  attr_accessor :things, :size
  attr_reader :box_count

  def initialize
    @things = []
    @size = V[512, 512]
    @tree = Quadtree.new(V[], @size)
    @box_count = 0

    20.times { add_box }
  end

  def update(game, elapsed)
    if game.keyboard.pressing? :equals
      add_box
    elsif game.keyboard.pressing? :minus
      remove_box
    end

    @tree.things = @things
    @things.each { |t| t.update(game, @things, elapsed) }
  end

  def draw(display)
    @things.each { |t| t.draw(display) }

    @tree.draw(display)

    display.stroke_color = Color[10, 10, 10]
    display.stroke_width = 3
    display.stroke_rectangle(V[], @size)
  end

  def width
    size.x
  end

  def height
    size.y
  end

  def depth
    size.z
  end

  def add_box
    things << Box.new(V[width * rand, height * rand])
    @box_count += 1
  end

  def remove_box
    @box_count -= 1 unless things.shift.nil?
  end
end
