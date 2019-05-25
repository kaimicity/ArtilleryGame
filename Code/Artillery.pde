import geomerative.* ;

final int backgroundColor = 0 ;
PGraphics playScreen ;
PGraphics welcomeScreen ;
PGraphics introScreen ;
PGraphics introMenu ;
PGraphics winnerTooltip ;
PGraphics chooseModel ;
String screen = "WELCOME" ;
String model ;
int transferCounter = 0 ;

PImage title ; 
float buttonWidth ;
float buttonHeight ;
float buttonGap ; //The gap between buttons.
float buttonPlat ;//The value of distance between the lowest button and the bottom of the screen
Button introButton ;
PImage leftButtonImage ;
PImage rightButtonImage ;
PImage AButtonImage ;
PImage DButtonImage ;
PImage WButtonImage ;
PImage SButtonImage ;
PImage MButtonImage ;
PImage spaceButtonImage ;
Button introBackButton ;
Button introPlayButton ;
Button playButton ;
Button exitButton ;
Button winBackButton ;
Button winReplayButton ;
Button p2P ;
Button p2C ;

final int fontColor = 255  ;
float lineHeight ;
float barrierLength ;
final int barrierColor = 255 ;
final int lineColor = 255 ;
Column[] columns ;
int[] cubeNumbers ;
float gap ;
float columnX ;
float columnSize ;
final int columnNumber = 200;

float canonAreaBorder ;
float canonWidth ;
float canonHeight ;
float canonIncrement ;
float fontSize ;

int p1Score = 0 ;
int p2Score = 0 ; 
float[] p1Elevation = {0, 0} ;
float[] p2Elevation = {0, 0} ;
int p1Strength = 0 ;
int p2Strength = 0 ;
int turn = 1 ; //Mark who is playing
int round ;
String next = "MOVE"; //Mark the present phase of the round.Its value could be "MOVE", "AIMING", "PRODUCE", "FLYING"

Canon p1Canon ;
color p1Color = color(0, 255, 0) ;
Canon p2Canon ;
color p2Color = color(0, 0, 255) ;
boolean aimLine = false ; //True if someone is adjusting the angle and power of launch
float aimAngle = PI/2;
float aimLength ;
final float aimRotateIncrement = PI / 100 ;
float powerIncrement = 1 ;
float power = 0 ;
final float maxPower = 20 ;
final color powerColor = color(255, 0, 0) ;
PVector AILeap;
float AIDestination ;
float AIRotateAngle ;
float AIPower ;
float p1MoveRecorder ;

Shell shell ;
float shellRadius ;
float producing ;// The counter of the process of producing the shell
final float shellMass = 20 ;
float producePropotion = 0.2 ;
float shellVelocityPropotion = 4.0 ;
float flying = 0; //True if the shell is flying

final float g = 4.9;
Gravity gravity = new Gravity(g); 

float initWindStrength = (-10 + (float)Math.random() * 20) /16 ;
Wind wind = new Wind(initWindStrength) ;// Change at the time both sides has finished a round
PFont f;
RFont buttonFont ;

//Initialze some data, including the size of screens, canons,shells, buttons, bricks, fonts... and load images.
//Also create some objects, including canons, buttons... Shell and bricks is not created in setup(), because their positions are not constant.
void setup() {
  fullScreen();
  //size(1000,800);
  title = loadImage("Title.png") ;
  leftButtonImage = loadImage("left.png") ;
  rightButtonImage = loadImage("right.png") ;
  AButtonImage = loadImage("A.png") ;
  DButtonImage = loadImage("D.png") ;
  WButtonImage = loadImage("W.png") ;
  SButtonImage = loadImage("S.png") ;
  MButtonImage = loadImage("M.png") ;
  spaceButtonImage = loadImage("Space.png") ;//These pictures are drew by myself. :-)
  smooth() ;
  RG.init(this) ;
  buttonWidth = 0.2 * width ;
  buttonHeight = 0.1 * height ;
  buttonGap = 0.05 * height ;
  buttonPlat = 0.1 * height ;
  playScreen = createGraphics(width, height) ;
  welcomeScreen = createGraphics(width, height) ;
  introButton = new Button((width - buttonWidth) / 2, height - buttonHeight * 3 - buttonGap * 2 - buttonPlat, buttonWidth, buttonHeight, "Introduction", welcomeScreen, 0, 0) ;
  playButton = new Button((width - buttonWidth) / 2, height - buttonHeight * 2 - buttonGap - buttonPlat, buttonWidth, buttonHeight, "Play", welcomeScreen,0 , 0) ;
  exitButton = new Button((width - buttonWidth) / 2, height - buttonHeight - buttonPlat, buttonWidth, buttonHeight, "Exit", welcomeScreen, 0, 0) ;
  introScreen = createGraphics(width / 2, (int)(height - introButton.getY()-buttonPlat+1)) ;
  introMenu = createGraphics(width / 2, (int)buttonPlat)  ;
  winnerTooltip = createGraphics(width / 2, height / 3 ) ;
  chooseModel = createGraphics(width / 5 + 1, height / 3 + (int)buttonHeight) ;
  introBackButton = new Button(0, 0.3 * introMenu.height, buttonWidth , buttonHeight / 2, "Back", introMenu, width / 4, height - buttonPlat) ;
  introPlayButton = new Button(introMenu.width - buttonWidth - 1 , 0.3 * introMenu.height, buttonWidth, buttonHeight / 2, "Play", introMenu, width / 4, height - buttonPlat) ;
  winBackButton = new Button(0.05 * winnerTooltip.width, 0.7 * winnerTooltip.height, buttonWidth , buttonHeight / 2, "Back", winnerTooltip, width / 4, height / 3) ;
  winReplayButton = new Button(winnerTooltip.width * 0.95 - buttonWidth , 0.7 * winnerTooltip.height, buttonWidth, buttonHeight / 2, "Play", winnerTooltip, width / 4, height / 3) ;
  p2P = new Button(chooseModel.width * 0.1, 0.2 * chooseModel.height, 0.8 * chooseModel.width, 0.25 * chooseModel.height, "VS Player", chooseModel, width * 2 / 5, introButton.getY()) ;
  p2C = new Button(chooseModel.width * 0.1, 0.55 * chooseModel.height, 0.8 * chooseModel.width, 0.25 * chooseModel.height, "VS Computer", chooseModel, width * 2 / 5, introButton.getY()) ;
  lineHeight = 0.1 * height ;
  barrierLength = 0.05 * height ;
  gap = 0.1 * width ;
  canonAreaBorder = 0.3 * width ;
  columnX = gap + canonAreaBorder ;
  columnSize =  (width - columnX * 2) / columnNumber ;
  columns = new Column[columnNumber] ;
  cubeNumbers = new int[columnNumber] ;
  initCubeNumbers() ;
  for( int i = 0 ; i< columnNumber ; i++){
    Column colomn = new Column(cubeNumbers[i], columnSize, columnX + i *columnSize, height-lineHeight-columnSize, playScreen) ;
    columns[i] = colomn ;
  }
  canonWidth= 0.05 * width ;
  canonHeight= 0.03 * width ;
  canonIncrement = 0.1*canonWidth;
  aimLength = 0.07 * width ;
  shellRadius = 0.01 * width ;
  fontSize= 0.01 * width ;
  f = createFont("Arial", fontSize, true) ; 
  buttonFont = new RFont("FreeSans.ttf", (int)(0.15*buttonWidth),CENTER) ; 
  p1Canon = new Canon(0.125 * width, height - lineHeight - canonHeight, 
     canonWidth, canonHeight, canonIncrement, 0, canonAreaBorder, p1Color, playScreen) ;
  p2Canon = new Canon(0.825 * width, height - lineHeight - canonHeight, 
     canonWidth, canonHeight, canonIncrement,width-canonAreaBorder, width, p2Color, playScreen) ;
}

//The variable "screen" marks the status of the game, then corresponding method could be called 
//and the corresponding PGraphics object(named as screen) could be shown.
void draw() { 
  if(screen.equals("WELCOME")){
    drawWelcomeScreen() ;
    image(welcomeScreen, 0, 0) ;
  }
  else if(screen.equals("INTRODUCTION")){
    //Introduction interface is combined by two parts:
    //  1.some introduction of operations;
    //  2.buttons at the bottom
    drawWelcomeScreen() ;
    image(welcomeScreen, 0, 0) ;
    drawIntroScreen() ;
    image(introScreen, width / 4, introButton.getY()) ;
    image(introMenu, width / 4, height - buttonPlat) ;
  }
  else if(screen.equals("CHOOSE_MODEL")){
    drawWelcomeScreen() ;
    image(welcomeScreen, 0, 0) ;
    drawChooseModel() ;
    image(chooseModel, width * 2 / 5, introButton.getY()) ;
  }
  else if(screen.equals("PLAY") || screen.equals("WINNER")){
    drawPlayScreen() ;
    image(playScreen, 0, 0) ;
     String whoWin = "";
     if(p1Score >= 10 && p2Score < 10)
       whoWin = "Player 1 win!" ;
     else if(p1Score < 10 && p2Score >= 10)
       whoWin = "Player 2 win!" ;
     else if(p1Score >= 10 && p2Score >= 10)
       whoWin = "Draw!" ;
     if(!whoWin.equals("")){
       drawWinnerTooltip(whoWin) ;
       image(winnerTooltip, width / 4, height / 3) ;
       screen = "WINNER" ;
     }
  }
}

//There are some buttons.When mouse is released, "screen" should change if these buttons are clicked.
//Buttons in this game mostly play roles as route.
void mouseReleased(){
  if(screen.equals("WELCOME")){
    if(playButton.isClicked()){
      initPlay() ;
      screen = "CHOOSE_MODEL" ;
    }
    else if(introButton.isClicked()){
      screen = "INTRODUCTION" ;
    }
    else if(exitButton.isClicked()){
      exit() ;
    }
  }
  else if(screen.equals("INTRODUCTION")){
    
    if(introPlayButton.isClicked()){
      initPlay() ;
      screen = "CHOOSE_MODEL" ;
    }
    else if(introBackButton.isClicked()){
      screen = "WELCOME" ;
    }
  }
  else if(screen.equals("CHOOSE_MODEL")){
    if(p2P.isClicked()){
      initPlay() ;
      model = "PLAYER" ;
      screen = "PLAY" ;
    }
    else if(p2C.isClicked()){
      initPlay() ;
      model = "COMPUTER" ;
      screen = "PLAY" ;
    }
  }
  else if(screen.equals("WINNER")){
    if(winReplayButton.isClicked()){
      initPlay() ;
      screen = "PLAY" ;
    }
    else if(winBackButton.isClicked()){
      screen = "WELCOME" ;
    }
  }
}
//Launch and return to start menu is reached by press key
void keyPressed() {
  if(screen.equals("PLAY"))
    if(key == ' ' && next.equals("AIM")){
      next = "PRODUCE" ;
      producing = 0 ;
      flying = 0 ;
    }
    else if(key == 'm' || key == 'M'){
      screen = "WELCOME" ;
    }
}

//This method is called when player press 'A', 'D', 'W', 'S', to show the panel of aiming and storing up.
//Input: canon summoning the panel, the offset of angel from the origin angle, the increment of power line
void showAim(Canon player, float angleRotated, float powerIncrement){
   playScreen.pushMatrix() ;
   playScreen.translate(player.getX() + player.getWidth() / 2, height - lineHeight) ;
   playScreen.noFill() ;
   playScreen.stroke(255) ;
   playScreen.strokeWeight(1) ;
   playScreen.arc(0, 0, player.getWidth() + player.getHeight(), player.getWidth() + player.getHeight(), - PI, 0) ;
   playScreen.fill(255) ;
   if(aimAngle <= 0 && angleRotated < 0)
     aimAngle = 0 ;
   else if(aimAngle >= PI && angleRotated > 0)
     aimAngle = PI ;
   else
     aimAngle = aimAngle + angleRotated ;
   if(power <= 0 && powerIncrement < 0)
     power = 0 ;
   else if(power >= maxPower && powerIncrement > 0)
     power = maxPower ;
   else
     power = power + powerIncrement ;
   playScreen.rotate(- aimAngle) ;
   playScreen.line(0, 0, aimLength, 0) ;
   playScreen.strokeWeight(5) ;
   if(next.equals("AIM"))
     playScreen.stroke(powerColor) ;
   else
     playScreen.stroke(255);
   playScreen.line(0, 0, power / maxPower * aimLength, 0);
   aimLine = true ;
   playScreen.popMatrix() ;
}

//This method will judge who is playing and call showAim() for the corresponding canon.
void showAimInTurn(float angleIncrement, float powerIncrement) {
  if(turn == 1){
    showAim(p1Canon, angleIncrement, powerIncrement) ;
  }
  else{
    showAim(p2Canon, angleIncrement, powerIncrement) ;
  }
}
//This method caculate the magnitude of elevation of launching.
void caculateElevator(){
  if(turn == 1){
    p1Elevation[0] = cutFloat(cos(aimAngle)) ;
    p1Elevation[1] = cutFloat(sin(aimAngle)) ;
  }
  else{
    p2Elevation[0] = cutFloat(cos(aimAngle)) ;
    p2Elevation[1] = cutFloat(sin(aimAngle)) ;
  }
}
 //Initialize some attributes of player then change the value of "turn" or finish the game
 void playerChange(){
   if(turn == 1){
     turn = 2 ;
     if(round == 1 && model.equals("COMPUTER"))
       AIInit() ;
     else if(model.equals("COMPUTER")){
       if(p1MoveRecorder > canonWidth){
         if(AIPower >= 15 )
           AIPower -= (int)Math.random() * 2 ;
         else
           AIRotateAngle -= (float)Math.random() * PI / 12 ;
       }
       else if(p1MoveRecorder < - canonWidth){
         if(AIPower <= 18 )
           AIPower += (int)Math.random() * 2 ;
         else
           AIRotateAngle += (float)Math.random() * PI / 12 ;
       }
     }
   }
   else if(turn == 2)
   {
     turn = 1 ;
     if(model.equals("COMPUTER"))
       p1MoveRecorder = 0 ;
   }
   aimLine = false ;
   aimAngle = PI / 2 ;
   power = 0 ;
   p1Elevation[0] = 0 ;
   p1Elevation[1] = 0 ;
   p2Elevation[0] = 0 ;
   p2Elevation[1] = 0 ;
   if(turn == 1){
     wind.changeRandomly() ;
     round++ ;
   }
   next = "MOVE" ;
 }
 
float cutFloat(float d) {
   return (float) Math.round(d * 1000) / 1000 ;
}

//If the launch key is pressed, the length of power line would keep reducing while
// the size of shell would be increasing, making it seem like that the shell is produced with power.
//Input: the canon producing the shell
void produceShell(Canon player){
  playScreen.pushMatrix() ;
  playScreen.translate(player.getX() + player.getWidth() / 2, height - lineHeight) ;
  playScreen.rotate(- aimAngle) ;
  float produceT = power / producePropotion ;
  playScreen.strokeWeight(5) ;
  playScreen.stroke(powerColor) ;
  playScreen.line(0, 0, power / maxPower * aimLength * (1 - producing / produceT), 0);
  playScreen.popMatrix() ;
  playScreen.noStroke();
  playScreen.fill(powerColor);
  playScreen.ellipse(player.getX() + player.getWidth() / 2+aimLength * cos(aimAngle) , height - lineHeight-aimLength*sin(aimAngle), producing/produceT*shellRadius*2, producing/produceT*shellRadius*2) ;
  if(producing < produceT)
    producing++ ;
  else if(producing == Math.floor(produceT)){
    next = "FLYING" ;
    PVector shellV = new PVector(power * cos(aimAngle), - power * sin(aimAngle)) ;
    PVector shellA = new PVector(0, 0) ;
    shellV.mult(shellVelocityPropotion) ;
    shell = new Shell(shellRadius, player.getX() + player.getWidth() / 2+aimLength * cos(aimAngle) , height - lineHeight-aimLength*sin(aimAngle), shellV, shellMass, shellA, playScreen) ;
    gravity.updateForce(shell) ;
    wind.updateForce(shell) ;
  }
}

//Randomly initialize the number of bricks
void initCubeNumbers(){
  int preCubeNumber = 5 + (int) (Math.random() * 5) ;
  for(int i = 0 ; i < columnNumber / 2 ; i++){
    cubeNumbers[i] = preCubeNumber ;
    preCubeNumber += (int) (Math.random() * 5) ;
  }
  preCubeNumber = 5 + (int) (Math.random() * 5) ;
  for(int i = columnNumber -1; i > columnNumber/2-1 ; i--){
    cubeNumbers[i] = preCubeNumber ;
    preCubeNumber += (int) (Math.random() * 5) ;
  }
}

//Initialize some play data
void initPlay(){
  p1Canon = new Canon(0.125 * width, height - lineHeight - canonHeight, 
     canonWidth, canonHeight, canonIncrement, 0, canonAreaBorder, p1Color, playScreen) ;
  p2Canon = new Canon(0.825 * width, height - lineHeight - canonHeight, 
     canonWidth, canonHeight, canonIncrement,width-canonAreaBorder, width, p2Color, playScreen) ;
  p1Score = 0 ;
  p2Score = 0 ; 
  p1Elevation[0] = 0 ;
  p1Elevation[1] = 0 ;
  p2Elevation[0] = 0 ;
  p2Elevation[1] = 0 ;
  p1Strength = 0 ;
  p2Strength = 0 ;
  aimLine= false;
  aimAngle = PI / 2 ;
  turn = 1 ;
  round = 1 ;
  initCubeNumbers() ;
  for( int i = 0 ; i< columnNumber ; i++){
    Column colomn = new Column(cubeNumbers[i], columnSize, columnX + i *columnSize, height-lineHeight-columnSize, playScreen) ;
    columns[i] = colomn ;
  }
  initWindStrength = -10 + (float)Math.random() * 20 ;
}

void AIInit(){
    AIDestination = width - p1Canon.getX() - canonWidth -canonWidth + (float)Math.random() * canonWidth * 2 ;//In the first round, AI should go to the point axisymmetric with player1;
  if(p1Canon.getX() < canonAreaBorder - canonWidth && p1Canon.getX() > (canonAreaBorder - canonWidth) / 2){
    AIRotateAngle = PI / 6 + (float)Math.random() * PI / 12 ;
}
  else{
    AIRotateAngle = (float)Math.random() * PI / 6 ;
  }
  AIRotateAngle = PI / 2 - AIRotateAngle ;
  AIPower = (float)Math.random() * 7 + 13 ;
  correctAIAttr() ;
}

//Correct the data of AI in case of it act illegally or unreasonably
void correctAIAttr(){
  if(AIDestination > width - canonWidth)
    AIDestination = width - canonWidth ;
  else if(AIDestination < width - canonAreaBorder)
    AIDestination = width - canonAreaBorder ;
  if(AIRotateAngle > 2 / 3 * PI)
    AIRotateAngle = 2 / 3 * PI ;
  else if(AIRotateAngle < PI * 7 / 12)
    AIRotateAngle = PI * 7 / 12 ;
  if(AIPower > maxPower)
    AIPower = maxPower ;
  else if(AIPower < 13)
    AIPower = 13 ;
    
}
//Following methods draw different screens or tootips
void drawPlayScreen(){
  playScreen.beginDraw() ;
  playScreen.background(backgroundColor) ;
  playScreen.strokeWeight(1) ;
  playScreen.stroke(lineColor) ;
  playScreen.line(0, height-lineHeight, width, height-lineHeight) ;
  playScreen.stroke(barrierColor) ;
  playScreen.line(canonAreaBorder, height - lineHeight, canonAreaBorder, height - (lineHeight + barrierLength));
  playScreen.line(width - canonAreaBorder, height - lineHeight, width - canonAreaBorder, height-(lineHeight + barrierLength));
  playScreen.noStroke() ;
  playScreen.textFont(f) ;
  playScreen.fill(fontColor) ; 
  playScreen.text("Player 1 Score: " + p1Score + " / 10", 0.03 * width, 0.03 * height) ;
  playScreen.text("Player 2 Score: " + p2Score + " / 10", 0.85 * width, 0.03 * height) ;
  playScreen.text("Player 1 Elevation: [" + p1Elevation[0] + ", " + p1Elevation[1] + "]", 0.03 * width, 0.06 * height) ;
  playScreen.text("Player 2 Elevation: [" + p2Elevation[0] + ", " + p2Elevation[1] + "]", 0.85 * width, 0.06 * height) ;
  playScreen.text("Player " + turn + " turn", 0.46 * width, 0.03 * height) ;
  playScreen.text("Round: " + round, 0.46 * width, 0.06 * height) ;
  playScreen.text("Present wind: " + wind.getStrength(), 0.46 * width, 0.09 * height) ;
  for( int i = 0 ; i< columnNumber ; i++){
    columns[i].draw() ;
  }
  p1Canon.draw() ;
  p2Canon.draw() ;
  if(!(model.equals("COMPUTER") && turn == 2)){
    if(keyPressed==true && ((next.equals("AIM")) || next.equals("MOVE"))){
      if (key == CODED) {
         if(keyCode == LEFT){
           if( turn == 1){
             p1Canon.moveToLeft() ;
             if(model.equals("COMPUTER"))
               p1MoveRecorder -= canonIncrement ;
           }
           else
             p2Canon.moveToLeft() ; 
         }
         else if(keyCode == RIGHT){
           if( turn == 1){
             p1Canon.moveToRight() ;
             if(model.equals("COMPUTER"))
               p1MoveRecorder += canonIncrement ;
           }
           else
             p2Canon.moveToRight() ;
         }
      }
      if(key == 'a' || key == 'A'){
        if(next.equals("MOVE"))
          next = "AIM";
        showAimInTurn(aimRotateIncrement, 0) ;
        caculateElevator();
      }
      else if(key == 'd' || key == 'D'){
        if(next.equals("MOVE"))
          next = "AIM";
        showAimInTurn(- aimRotateIncrement, 0) ;
        caculateElevator();
      }
      else if(key == 'w' || key == 'W'){
        if(next.equals("MOVE"))
          next = "AIM";
        showAimInTurn(0, powerIncrement) ;
      }
      else if(key == 's' || key == 'S'){
        if(next.equals("MOVE"))
          next = "AIM";
        showAimInTurn(0, - powerIncrement) ;
      }
      else if(aimLine&& next.equals("MOVE"))
        showAimInTurn(0, 0) ;
    }
  }
  else{
    if(next.equals("MOVE")){
      if(AIDestination - p2Canon.getX() > -canonIncrement && AIDestination - p2Canon.getX() < canonIncrement){
        next = "AIM" ;
      }
      else{
        p2Canon.moveToPoint(AIDestination) ;
      }
    }
    else if(next.equals("AIM")){
      showAimInTurn(aimRotateIncrement, 0) ;
      if(aimAngle >= AIRotateAngle){
        showAimInTurn(0, powerIncrement) ;
        if(power >= AIPower){
          next = "PRODUCE" ;
          producing = 0 ;
          flying = 0 ;
        }
      }
    }
  }
  if(aimLine && !keyPressed && next.equals("AIM"))
    showAimInTurn(0, 0) ;
  if(next.equals("PRODUCE")){
    showAimInTurn(0, 0) ;
    if(power > 0)
      if(turn == 1)
        produceShell(p1Canon) ;
      else
        produceShell(p2Canon);
    else
      playerChange();
    }
    if(next.equals("FLYING")){
      showAimInTurn(0, 0) ;
      if(!shell.collisionWithGround(playScreen.height - lineHeight) && !shell.collisionWithColumns(columns) && !shell.collisionWithCanon(p1Canon) && !shell.collisionWithCanon(p2Canon)){
        if(shell.getPosition().x <= 0 && model.equals("COMPUTER") && turn == 2){
          AIPower -= (int)Math.random() * 4 ;
          AIRotateAngle -= (float)Math.random() * PI / 3 ;
        }
        shell.draw() ;
      }
      else if(shell.collisionWithCanon(p1Canon)){
        p2Score++ ;
        playerChange() ;
      }
      else if(shell.collisionWithCanon(p2Canon)){
        p1Score++ ;
        if(model.equals("COMPUTER")){
          int i = (int)Math.random() * 2 ;
          AIDestination = AIDestination - 0.1 * width + (float)Math.random() * (0.2 * width + canonWidth) ;
          if(i < 1){
            AIDestination = shell.getPosition().x + (float)Math.random() * 0.1 * width ;
            AIRotateAngle += (float)Math.random() * PI / 12 ;
          }
          else if(i > 1){
            AIDestination = shell.getPosition().x - (float)Math.random() * 0.1 * width ;
            AIRotateAngle -= (float)Math.random() * PI / 12 ;
          }
        }
        playerChange() ;
      }
      else {
        if(model.equals("COMPUTER")){
          float shellX = shell.getPosition().x ;
          //AI adjust its position according to the droppoint of the shell of P1
          if(shell.collisionWithGround(playScreen.height - lineHeight)){
            if(turn == 1){
              if(AIDestination == width - canonWidth && shellX > width - 2 * canonWidth){//The droppoint is at just the left of the AI while AI is at the most right of the screen
                 AIDestination = shellX - (float)Math.random() * 0.1 * width ;
                 AIRotateAngle -= (float)Math.random() * PI / 6 ;
              }
              else if(AIDestination == width - canonAreaBorder && shellX < width - canonAreaBorder + canonWidth){//The droppoint is at just the right of the AI while AI is at the most left of the area
                 AIDestination = shellX + (float)Math.random() * 0.1 * width ;
                 AIRotateAngle += (float)Math.random() * PI / 6 ;
              }
              else if(shellX > AIDestination + canonWidth){//Droppoint is at the right of AI
                AIDestination -= (float)Math.random() * 0.1 * width ;
                AIRotateAngle -= (float)Math.random() * PI / 12 ;
              }
              else if(shellX < AIDestination && shellX > width - canonAreaBorder)//Droppoint is at the left of AI
                AIDestination += (float)Math.random() * 0.1 * width ;
                AIRotateAngle += (float)Math.random() * PI / 12 ;
            }
            else if(turn == 2){
              float p1X = p1Canon.getX() ;
              if(shellX < p1X)
                if(AIPower >= 15)
                  AIPower -= (int)Math.random() * 4 ;
                else
                  AIRotateAngle -= (float)Math.random() * PI / 12 ;
              else if(shellX > p1X + canonWidth)
                if(AIPower <= 18 )
                  AIPower += (int)Math.random() * 4 ;
                else
                  AIRotateAngle += (float)Math.random() * PI / 12 ;
            }
          }
        }
        playerChange() ;
      }
      correctAIAttr() ;
    }
  playScreen.endDraw() ;
  
}

void drawWelcomeScreen(){
  welcomeScreen.beginDraw() ;
  welcomeScreen.background(backgroundColor) ; 
  welcomeScreen.image(title, 0.2 * width,0.1*height, 0.6*width, 0.6*height) ;
  introButton.draw() ;
  playButton.draw() ;
  exitButton.draw() ;
  welcomeScreen.endDraw() ;
}

void drawIntroScreen(){
  introScreen.beginDraw() ;
  introScreen.background(125) ;
  introScreen.pushMatrix() ;
  introScreen.translate(introScreen.width / 2, 0.15 * introScreen.height) ;
  RCommand.setSegmentLength(3);
  RCommand.setSegmentator(RCommand.UNIFORMLENGTH);
  RGroup myGroup = buttonFont.toGroup("INTRODUTION"); 
  myGroup = myGroup.toPolygonGroup();
  RPoint[] myPoints = myGroup.getPoints();
  for (int i=0; i<myPoints.length; i++) {
    introScreen.ellipse(myPoints[i].x, myPoints[i].y, 2, 5);
  }
  introScreen.popMatrix() ;
  introScreen.fill(0) ;
  introScreen.textFont(f) ;
  introScreen.textSize(fontSize * 1.5) ;
  introScreen.image(leftButtonImage, 0.05 * introScreen.width,0.2*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.image(rightButtonImage, 0.15 * introScreen.width,0.2*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.text("Left and Right key: Control the tank.",0.3 * introScreen.width,0.25 * introScreen.height) ;
  introScreen.image(AButtonImage, 0.05 * introScreen.width,0.35*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.image(DButtonImage, 0.15 * introScreen.width,0.35*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.text("A / D key: Control the launch angle.",0.3 * introScreen.width,0.4 * introScreen.height) ;
  introScreen.image(WButtonImage, 0.1 * introScreen.width,0.5*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.image(SButtonImage, 0.1 * introScreen.width,0.6*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.text("W / S key: Control the launch power.",0.3 * introScreen.width,0.6 * introScreen.height) ;
  introScreen.image(spaceButtonImage, 0.1 * introScreen.width,0.75*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.text("Space key: Launch shell.",0.3 * introScreen.width,0.8 * introScreen.height) ;
  introScreen.image(MButtonImage, 0.1 * introScreen.width,0.9*introScreen.height, 0.1*introScreen.width, 0.09*introScreen.height) ;
  introScreen.text("M key: Return to the start menu.",0.3 * introScreen.width,0.95 * introScreen.height) ;
  introScreen.endDraw() ;
  introMenu.beginDraw() ;
  introBackButton.draw() ;
  introPlayButton.draw() ;
  introMenu.endDraw() ;
}

void drawWinnerTooltip(String who){
  winnerTooltip.beginDraw() ;
  winnerTooltip.background(125) ;
  winnerTooltip.textFont(f) ;
  winnerTooltip.textSize(fontSize * 1.5) ;
  winnerTooltip.fill(0) ;
  winnerTooltip.textAlign(CENTER) ;
  winnerTooltip.text(who, winnerTooltip.width / 2, 0.2 * winnerTooltip.height) ;
  winBackButton.draw() ;
  winReplayButton.draw() ;
  winnerTooltip.endDraw() ;
}

void drawChooseModel(){
  chooseModel.beginDraw() ;
  chooseModel.background(125) ;
  p2P.draw() ;
  p2C.draw() ;
  chooseModel.endDraw() ;
}
