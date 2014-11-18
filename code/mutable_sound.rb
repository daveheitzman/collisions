class MutableSound < Sound 

  def initialize 
    super
    @@mute=false 
  end

  def play 
    super if !@@mute 
  end  

  def self.mute!
    @@mute=true 
  end 

  def self.un_mute!
    @@mute=false  
  end 
end 