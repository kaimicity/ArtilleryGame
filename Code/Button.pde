import geomerative.* ;
class Button{
  
  PVector position ;
  float buttonWidth ;
  float buttonHeight ;
  String buttonText ;
  RFont f ; //To make it more goodlooking, RFont from library Geomerative is used in button
  PGraphics location ;//The contatiner(PGraphics) of the button
  PVector locationPosition ;//To judge if mouse is in the area of button, the offsets of the container are needed
  
  
  Button(float x, float y, float buttonWidth, float buttonHeight, String buttonText, PGraphics location, float locationX, float locationY){
    this.position = new PVector(x, y) ;
    this.buttonWidth = buttonWidth ;
    this.buttonHeight = buttonHeight ;
    this.buttonText = buttonText ;
    f = new RFont("FreeSans.ttf", (int)(0.15*buttonWidth),CENTER) ; 
    this.location = location ;
    this.locationPosition = new PVector(locationX, locationY) ;
  }
  
  float getX(){
    return position.x ;
  }
  
  float getY(){
    return position.y ;
  }
  
  //Judge if the mouse is in the button
  boolean isHovered(){
    if((mouseX - locationPosition.x)> position.x && (mouseX- locationPosition.x) < position.x + buttonWidth && (mouseY - locationPosition.y) > position.y && (mouseY - locationPosition.y) < position.y + buttonHeight){
      return true ;
    }
    else{
      return false ;
    }
  }
  
  //Same as isHovered(), except the name
  boolean isClicked(){
    return isHovered() ;
  }
  
  //Show the text with Geomerative library
  void showText(){
      location.pushMatrix() ;
      location.noFill();
      location.translate(position.x + buttonWidth / 2, position.y + 0.7 * buttonHeight);//Use translate() to definite the location of text,which is different from the normal text() method
      RCommand.setSegmentLength(buttonWidth/100);//Definite the density of points
      RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
      RGroup myGroup = f.toGroup(buttonText); 
      myGroup = myGroup.toPolygonGroup();
      RPoint[] myPoints = myGroup.getPoints();
      for (int i=0; i<myPoints.length; i++) {
        location.ellipse(myPoints[i].x, myPoints[i].y, 2, 5);
      }
      location.popMatrix() ;
  }
  void draw(){
    //Button has three status: normal, is hovered, is clicked.Each status has a special color scheme.
    if(!isHovered()){
      location.fill(255) ;
      location.stroke(0) ;
      location.rect(position.x, position.y, buttonWidth, buttonHeight) ;
       showText() ;
    }
    else if(!mousePressed && isHovered()){
      location.fill(0) ;
      location.stroke(255) ;
      location.rect(position.x, position.y, buttonWidth, buttonHeight) ;
      showText() ;
    }
    else{
      location.fill(125) ;
      location.stroke(255) ;
      location.rect(position.x, position.y, buttonWidth, buttonHeight) ;
      showText() ;
    }
  }
  
}
