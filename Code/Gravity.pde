class Gravity extends ForceGenerator{
  float g ;
  PVector gravity ;
  Gravity(float g) {
    this.g = g ; 
    this.gravity = new PVector(0, g);
  }
  
  void updateForce(Particle p){
    PVector gravityForce = this.gravity.mult(p.getMass()) ;
    p.addAccelerate(gravityForce) ;
  }
}
