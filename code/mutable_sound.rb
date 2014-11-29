class MutableSound < Sound 

  def initialize 
    super
    @@mute=false 
  end

  def play 
    if @@mute 
      return self 
    else 
      super 
    end 
  end  

  def self.mute!
    @@mute=true 
    return self 
  end 

  def self.un_mute!
    @@mute=false
    return self 
  end 
end 