module Utils
  HALF_PI=Box::HALF_PI
  def collide( smd1, smd2)
    #speed mass dir , or Box-derived thing
    if smd1.is_a?(Box)
      smd1=[smd1.speed,1,smd1.dir]
    end 
    if smd2.is_a?(Box)
      smd2=[smd2.speed,1,smd2.dir]
    end 
    vel_x=Math.cos( smd1[2]-HALF_PI )*smd1[0]*smd1[1] + Math.cos( smd2[2]  - HALF_PI)*smd2[0]*smd2[1]
    vel_y=Math.sin( smd1[2]-HALF_PI )*smd1[0]*smd1[1] + Math.sin( smd2[2]  - HALF_PI)*smd2[0]*smd2[1]

    dir = Math.atan2( vel_x  , -vel_y )
    speed = ( (vel_x )**2 + (vel_y)**2 )**0.5
    [speed, smd1[1], dir]
  end 
end 
