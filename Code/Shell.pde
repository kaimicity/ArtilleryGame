//Shell is a subclass of particle
class Shell extends Particle {
  
  float radius ;
  final color shellColor = color(255, 0, 0) ;
   
  Shell(float radius, float x, float y, PVector v, float mass, PVector a, PGraphics location){
    this.radius = radius ;
    this.position = new PVector(x, y) ;
    this.velocity = v;
    this.accelerate = a ;
    this.mass = mass ;
    this.location = location ;
  }
  
  
  void draw(){
    location.fill(shellColor) ;
    location.noStroke() ;
    integrate() ;
    location.ellipse(position.x, position.y, radius * 2, radius * 2) ;
  }
  
  //Collision detection of shell and ground line.
  //Input: Y-axis of ground line
  boolean collisionWithGround(float lineY){
    return (position.y + radius >= lineY) ;
  }
  
  //Collision detection of shell and brick columns.
  //Input: Array of columns
  boolean collisionWithColumns(Column[] columns){
    for(int i = 0 ; i < columns.length ; i++){
      Column column = columns[i] ;
      if(collisionBetweenCircleAndSquare(position.x, position.y, radius, 
        column.getX() + column.getWidth() / 2, column.getY() - column.getHeight() / 2, 
        column.getWidth(), column.getHeight())){
        //If there is a collision between shell and column, this column and the ones near it would be partly destroyed.
        trimColumn(column) ;
        if(i > 9){
          for(int j = 1 ; j < 10 ;j++)
            trimColumn(columns[i-j]) ;
        }
        else{
          for(int j = 1 ; j < i ;j++)
            trimColumn(columns[i-j]) ;
        }
        if(i < columns.length - 10){
          for(int j = 1 ; j < 10 ;j++)
            trimColumn(columns[i+j]) ;
        }
        else{
          for(int j = 1; j < columns.length-1-j;j++)
            trimColumn(columns[i+j]) ;
        }
        return true ;
        }
    }
    return false;
  }
  
  //Collision detection of shell and canon, logically similar with that of shell and columns.
  //Input: Canon going to be detected.
  boolean collisionWithCanon(Canon canon){
    return collisionBetweenCircleAndSquare(position.x, position.y, radius,
    canon.getX() + canon.getWidth() / 2, canon.getY() + canon.getHeight() / 2, 
    canon.getWidth(), canon.getHeight()) ;
  }
  
  private void trimColumn(Column column){
    if(column.getNumber() >= 20)
      column.setNumber(column.getNumber() - 20) ;
    else
      column.setNumber(0) ;
  }
  
}
