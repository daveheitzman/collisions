class MutableSound < Sound 

  def initialize 
    super
    @@mute=false 
  end

  def play 
    super if !@@mute 
  end  

  def self.mute!
    super
    @@mute=true 
  end 

  def self.un_mute!
    super
    @@mute=false  
  end 
end 