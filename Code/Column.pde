//This class is the colomns made by cube bricks
class Column{
  
  int number ;
  float size ;
  PVector position ;
  PGraphics location ;
  
  final int colorDecrement = 10 ;//The color of cubes in different height is  different.
  
  Column(int number, float size, float x, float y, PGraphics location){
    this.number = number ;
    this.size = size ;
    this.position = new PVector(x, y) ;
    this.location = location ;
  }
   float getX(){
     return position.x ;
   }
   float getY(){
     return position.y ;
   }
   float getWidth(){
     return size ;
   }
   float getHeight(){
     return size * number ;
   }
   int getNumber(){
     return number ;
   }
   void setNumber(int n){
     this.number = n ;
   }
  void draw(){
    for(int i = 0 ; i < number ; i++ ){
      location.fill(255) ;
      location.rect( position.x, position.y - i * size, size, size);
    }
  }
}
