//Although there is only one kind of particle(Shell), it is possible to extend other 
//functions with this class(such as exploision).
class Particle{
  PVector position ; 
  PVector velocity ;
  PVector accelerate;
  float mass ;
  final float damping = 0.995 ;
  PGraphics location ;
  
  
  PVector getPosition(){
    return this.position ;
  }
  PVector getVelocity(){
    return this.velocity ;
  }
  float getMass(){
    return this.mass ;
  }
  
  void integrate(){
    position.add(velocity) ;
    velocity.add(accelerate) ;
    velocity.mult(damping) ;
  }
  
  void addAccelerate(PVector force){
    float invMass = 1 / mass ;
    accelerate.add(force.mult(invMass)) ;
  }
  
  //Collision detection of a circle and a square.
  //Input: the center point of two shapes
  boolean collisionBetweenCircleAndSquare(float cx, float cy, float cr, float sx, float sy, float sw, float sh){
    float cLeft = cx - cr ;
    float cRight = cx + cr ;
    float cTop = cy - cr ;
    float cBottom = cy + cr ;
    float sLeft = sx - sw / 2 ;
    float sRight = sx + sw / 2 ;
    float sTop = sy - sh / 2 ;
    float sBottom = sy + sh / 2 ;
    if(cx == sx){
      if(Math.abs(cy - sy) <= cr + sh /2)
        return true ;
      else
        return false ;
    }
    else if(cLeft <= sLeft && cRight >= sRight && cTop <= sTop && cBottom >= sBottom){
      return true ; // The situation that the square is in the circle;
    }
    else if(cLeft >= sLeft && cRight <= sRight && cTop >= sTop && cBottom <= sBottom){
      return true ; // The situation that the cirvle is in the square;
    }
    else{
      //Find the point on the circle and at the same time, on the line connecting the center point of circle and the square
      //If this point is in the sqruare, then two shapes are collided.  
      double k = (sy - cy) / (sx - cx) ;
      double b = sy - k * sx ; //Coefficient of the expression of the line
      double fa = k * k + 1 ;
      double fb = 2 * (k * b - k * cy -cx) ;
      double fc = Math.pow((b - cy), 2) + cx * cx - cr * cr ;//Coefficient of equation group of (x-cx)^2+(y-cy)^2=r^2 and y=k*x+b
      double x1 = (- fb + (float)Math.sqrt(fb * fb - 4 * fa * fc)) / (2 * fa) ;
      double x2 = (- fb - (float)Math.sqrt(fb * fb - 4 * fa * fc)) / (2 * fa) ;
      double y1 = k * x1 + b ;
      double y2 = k * x2 + b ;
      boolean p1InSquare = x1 < sx + sw / 2 && x1 > sx - sw / 2 && y1 < sy + sh /2 && y1 > sy -sh / 2 ;
      boolean p2InSquare = x2 < sx + sw / 2 && x2 > sx - sw / 2 && y2 < sy + sh /2 && y2 > sy -sh / 2 ;
      if(p1InSquare || p2InSquare){
        return true ;
      }
      else 
        return false ;
    }
  }
}
