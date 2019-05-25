class Canon{
  
  PVector position ;
  float canonWidth,canonHeight ;
  float moveIncrement ;
  float leftBorder,rightBorder ;//Limit the available area of the canon
  color canonColor ;
  PGraphics location ;
  
  Canon(float  x, float y, float canonWidth, float canonHeight, float moveIncrement, float leftBorder, float rightBorder, color canonColor, PGraphics location){
     position = new PVector(x,y) ;
     this.canonWidth = canonWidth ;
     this.canonHeight = canonHeight ; 
     this.leftBorder = leftBorder ;
     this.rightBorder = rightBorder ;
     this.moveIncrement = moveIncrement ;
     this.canonColor = canonColor ;
    this.location = location ;
  }
  
  float getX(){
    return (float) position.x ;
  }
  float getY(){
    return (float) position.y ;
  }
  float getWidth(){
    return canonWidth ;
  }
  float getHeight(){
    return canonHeight ;
  }
  
  void draw(){
    location.fill(canonColor) ;
    location.rect(position.x, position.y, canonWidth, canonHeight) ;
  }
  
  //Following methods are called during the process of moving. 
  //The the position of canon would change in the value of moveIncrement.It is seemed like the canon is moving 
  //smoothly as long as the moveIncrement is small enough.
  void moveToLeft(){
    position.x -= moveIncrement ;
    if( position.x <= leftBorder)
      position.x = leftBorder ; 
  }
  
  void moveToRight(){
    position.x += moveIncrement ;
    if(position.x >= rightBorder - canonWidth)
      position.x = rightBorder - canonWidth ;
  }
  
  //Following methods are called by AI.
  //Besides moving, they have destination coordinate as inputed parameter.
  void moveToPoint(float des){
      if(position.x < des )
        position.x += moveIncrement ;
      else if(position.x > des )
        position.x -= moveIncrement ;
  }
}
