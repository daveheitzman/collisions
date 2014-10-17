class Quadtree
  MAX_THINGS = 5
  MAX_LEVELS = 5

  def initialize(position, size, level = 0)
    @position = position
    @size = size
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
    d.stroke_color = C['#f33']
    d.stroke_width = 1
    d.stroke_rectangle(@position, @size)
    @nodes.each { |n| n.draw(d) }
  end

  private

  def split
    half_size = @size / 2

    @nodes = [
      Quadtree.new(V[@position.x + half_size.x, @position.y], half_size,
                   @level + 1),
      Quadtree.new(@position, half_size, @level +1),
      Quadtree.new(V[@position.x, @position.y + half_size.y], half_size,
                   @level + 1),
      Quadtree.new(@position + half_size, half_size, @level + 1)
    ]

    @things.each do |thing|
      node = node_for(thing)
      node << @things.delete(thing) unless node.nil?
    end
  end

  def node_for(thing)
    return if @nodes.empty? || thing.nil?

    middle = @position + @size / 2

    fits_top = thing.bottom < middle.y
    fits_bottom = thing.top > middle.y

    # If fits left...
    if thing.right < middle.x
      if fits_top
        @nodes[1]
      elsif fits_bottom
        @nodes[2]
      end

    # If fits right...
    elsif thing.left > middle.x
      if fits_top
        @nodes[0]
      elsif fits_bottom
        @nodes[3]
      end
    end
  end
end
