class Wind extends ForceGenerator{
  
  float strength ;
  PVector windForce ;
  
  Wind(float strength){
    this.strength = strength ;
    this.windForce = new PVector(this.strength, 0) ;
  } 
  
  void updateForce(Particle p){
    p.addAccelerate(this.windForce) ;
  }
  
  float getStrength(){
    return this.strength ;
  }
  void changeRandomly(){
    this.strength = -10 + (float)Math.random() * 20 ;
    this.windForce = new PVector(this.strength, 0) ;
  }
}
