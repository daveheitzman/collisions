require 'quadtree'

class Scene
  BORDER_COLOR = Color[10, 10, 10]

  attr_accessor :things, :width, :height
  attr_reader :box_count

  def initialize
    @box_repro_chance=0.2
    @width = 512
    @height = 512
    @things = []
    #@tree = Quadtree.new(0, 0, @width, @height)
    @box_count = 0

    100.times { add_box }
  end

  def update(game, elapsed)
    @aa=V[1,1]
    if game.keyboard.pressing? :equals
      add_box
    elsif game.keyboard.pressing? :minus
      remove_box
    end

    #@tree.things = @things
    #@things.each { |t| t.update(game, @things, elapsed) }
    %x{
      for (var i = 0; i < self.things.length; i++) {
        self.things[i].$update(game, self.things, elapsed);
      }
    }
    collide_boxes 
  end

  def draw(display)
    #@things.each { |t| t.draw(display) }
    %x{
      for (var i = 0; i < self.things.length; i++) {
        self.things[i].$draw(display);
      }
    }

    #@tree.draw(display)

    display.stroke_color = BORDER_COLOR
    display.stroke_width = 3
    display.stroke_rectangle(0, 0, @width, @height)
  end

  def collide_boxes

    @things.each_with_index do |thing, i|
      b1_ind=i
      b2_ind=nil
      next if thing.nil?
      collided_tmp=thing.in_collision
      
      @things.each_with_index do |thing2, i2| 
        next if thing == thing2 || thing2.nil?
        if thing.colliding?(thing2)
          thing.in_collision = true 
          b2_ind=i2
          break
        end 
        thing.in_collision=false
      end 
      
      if !collided_tmp && thing.in_collision
        #collision starting
        if things[b1_ind].filled && things[b2_ind].filled 
          # two boxes, both filled collide => new box ! 
          add_box
        elsif !things[b1_ind].filled && !things[b2_ind].filled
          # two boxes, both empty collide => remove both box ! 
          @things[b1_ind]=nil    
          @things[b2_ind]=nil
        else 
          #two boxes, one full, one not -- full one dies 
          if @things[b1_ind].filled
            @things[b1_ind]=nil
          elsif @things[b2_ind].filled 
            @things[b2_ind]=nil
          end         
        end 
      elsif collided_tmp && !thing.in_collision 
        #collision ending
      end 
    end
    @things.compact!
    @box_count=@things.size
  end 

  def add_box
    things << Box.new(@width * rand, @height * rand)
    @box_count += 1
  end

  def remove_box
    @box_count -= 1 unless things.shift.nil?
  end
end
