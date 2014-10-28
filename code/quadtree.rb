class Quadtree
  MAX_THINGS = 5
  MAX_LEVELS = 5
  COLOR = Color['#f33']

  def initialize(x, y, width, height, level = 0)
    @x = x
    @y = y
    @width = width
    @height = height
    @level = level
    @things = []
    @nodes = []
  end

  def clear
    @things.clear
    @nodes.each(&:clear)
  end

  def <<(thing)
    node = node_for(thing)

    unless node.nil?
      node << thing
      return
    end

    @things << thing

    split if @nodes.empty? && @things.count > MAX_THINGS && @level < MAX_LEVELS
  end

  def things=(list)
    clear
    list.each { |t| self << t }
  end

  def things_near(thing, list = [])
    node = node_for(thing)
    list = node.things_near(thing, list) unless node.nil?
    list + @things
  end

  def draw(d)
    d.stroke_color = COLOR
    d.stroke_width = 1
    d.stroke_rectangle(@x, @y, @width, @height)
    @nodes.each { |n| n.draw(d) }
  end

  private

  def split
    half_width = @width / 2
    half_height = @height / 2
    next_level = @level + 1

    @nodes = [
      Quadtree.new(@x + half_width, @y, half_width, half_height, next_level),
      Quadtree.new(@x, @y, half_width, half_height, next_level),
      Quadtree.new(@x, @y + half_height, half_width, half_height, next_level),
      Quadtree.new(@x + half_width, @y + half_height, half_width, half_height,
                   next_level)
    ]

    @things.each do |thing|
      node = node_for(thing)
      node << @things.delete(thing) unless node.nil?
    end
  end

  def node_for(thing)
    return if @nodes.empty? || thing.nil?

    middle_x = @x + @width / 2
    middle_y = @y + @height / 2

    fits_top = thing.bottom < middle_y
    fits_bottom = thing.top > middle_y

    # If fits left...
    if thing.right < middle_x
      if fits_top
        @nodes[1]
      elsif fits_bottom
        @nodes[2]
      end

    # If fits right...
    elsif thing.left > middle_x
      if fits_top
        @nodes[0]
      elsif fits_bottom
        @nodes[3]
      end
    end
  end
end
