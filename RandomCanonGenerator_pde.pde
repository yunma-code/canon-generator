//Yun Ma
/* Generative Canon
In Maxmsp patch, a generative canon is implemented with default pitches and intervals. 
Users can click the buttons and switches on the Processing canvas, 
to control on/off switch,pitch/tone selections to create their own generative canon. 
The background of the Processing Canvas is a visual representation of the generative canon. 
Colors, shapes, movements are 
connected to the max patch and will represent the composition in different aspects. 
*/

//Import oscp5 library
import netP5.*;
import oscP5.*;

//declare variables to send/receive osc messages
OscP5 oscP5;
NetAddress remoteAddress;


//declare other variables
int x, y, z;
float counter = 0;
color playbuttoncolor = color(255);
int transpose = 0;
int volume = 50;

//declare trigger values that is will turn on certain patterns in the sketch
int circletrigger = 0;
int voice1trigger = 0;
int voice2trigger = 0;
int voice3trigger = 0;

// global variables: number of circles (300); initial counter value as 0;
int  numOfCircle = 500;
int numOfLine1 = 100;

// Declaring float arrays and color arrays as empty arrays. 
float[] initialX1Array = new float[numOfLine1];
float[] initialY1Array = new float[numOfLine1];
color[] colorL1Array = new color[numOfLine1];
color[] colorL2Array = new color[numOfLine1];
color[] colorL3Array = new color[numOfLine1];

 
float[] initialXArray = new float[numOfCircle];
float[] initialYArray = new float[numOfCircle];
color[] colorCArray = new color[numOfCircle];

void setup(){

//Use for loop for three sets of lines and circles. 
//Each line section represents one voice in the canon.
  for(int i = 0; i < numOfLine1; i++){
    initialX1Array[i] = random(0, width);
    initialY1Array[i] = random(0, height);
    colorL1Array[i] = color(random(0, 150), random(0, 100), 50, 2);
    colorL2Array[i] = color(random(150, 255), 50, random(0, 50), 2);
    colorL3Array[i] = color(50, random(150, 255), random(100, 200), 2);
  }
  
  for(int i = 0; i < numOfCircle; i++){
    initialXArray[i] = random(0, width);
    initialYArray[i] = random(0, height);
    colorCArray[i] = color(random(100, 255), random(50, 255), random(0, 100), random(0, 3));
  }
  
  background(0);
  fullScreen();
  
  //Open the gate into processing at port 9031. 
  oscP5 = new OscP5(this, 9031);
  //Set up new location of the software receiving processing messages.
  remoteAddress = new NetAddress("127.0.0.1", 9080);
  
}

void draw(){
  
  noStroke();
 
 //Set up transpose setting controlled by mouseY. 
 //When mouseY moves, pitch contents will be transposed by half step.
  if(mousePressed) transpose = mouseY/11;
  else transpose = 0;
  OscMessage transposeMessage = new OscMessage("/transpose");
  transposeMessage.add(transpose);
  oscP5.send(transposeMessage, remoteAddress);
  

  //loop through each line sections. Using noiseseed to generate 
  //different positions of line.Each line section will be placed in 
  //slightly different positions to create the effect. 
  for(int i = 0; i < numOfLine1; i++){
    noiseSeed(i);
    //fill(colorL1Array[i]);
    float velocityX = 200*noise(counter, 5);
    float velocityY = 200*noise(counter, 2);
    stroke(colorL1Array[i]);
    strokeWeight(0.5);
    
  //Use if statement to let max patches to trigger each line section. 
  //When it is triggered in the patch, the value turns to 1, and a 
  //new line section will starts to appear. Same for the below three line sections. 
    if(voice1trigger == 1){ 
      line(initialX1Array[i] + velocityX + 20, 100, 
      initialY1Array[i] + velocityY + 20, 1000);}
  }
  
  
  for(int i = 0; i < numOfLine1; i++){
    noiseSeed(i);
    //fill(colorL2Array[i]);
    float velocityX1 = 300*noise(counter, 1) - 200;
    float velocityY1 = 100*noise(counter, 2) + 100;
    stroke(colorL2Array[i]);
    strokeWeight(0.5);
    
    if(voice2trigger == 1){ 
      //stroke(50, 100, 0, 10);
      line(initialX1Array[i] + velocityX1, 100, 
      initialY1Array[i] + velocityY1, 1000);}
  }
  for(int i = 0; i < numOfLine1; i++){
    noiseSeed(i);
    //fill(colorL3Array[i]);
    float velocityX2 = 350*noise(counter, 1) + 400;
    float velocityY2 = 100*noise(counter, 2) - 100;
    stroke(colorL3Array[i]);
    strokeWeight(0.5);
    
    if(voice3trigger == 1){ 
      //stroke(50, 50, 0, 10);
      line(initialX1Array[i] + velocityX2, 100, 
      initialY1Array[i] + velocityY2, 1000);}
   }
   
   //For circle shapes, the max patch will triggered it 
   //to appear when the repeative note section is triggered. 
   for(int i = 0; i < numOfCircle; i++){
     noiseSeed(i);
     fill(colorCArray[i]);
     float velocityX3 = 200*noise(counter, 1);
     float velocityY3 = 600*noise(counter, 1);
     
     if(circletrigger == 1){ 
       ellipse(initialXArray[i] + velocityX3, initialYArray[i] + velocityY3, 5, 5);
     }
   }
   
   //Use a counter to control the speed for the visual performance. 
   counter += 0.003;
   
  //set up for the play button on the top left. 
  strokeWeight(4);
  stroke(150, 0, 0, 40);
  ellipse(50, 50, 50, 50);
  fill(playbuttoncolor);
  
  //set up for the text explanation on the top. 
  String s = "Press P to start. Move the mouse vertically to transpose.";
  textSize(25);
  fill(255);
  text(s, 200, 35, 500, 500);  
  
   
  
  
}


void keyPressed(){
  
  //Use keypressed function to start the whole composition. 
  //Also to trigger the playing text. 
  if(key == 'p'){
    playbuttoncolor = color(255, 150, 0);
    textSize(20);
    text("Playing...", 90, 50);
    
    
    //Connect this with the max patch to switch the whole thing on. 
    OscMessage myTrigger = new OscMessage("/trigger");
    myTrigger.add(1);
    oscP5.send(myTrigger, remoteAddress);
    
  }
  
}

//Listener function for incoming osc messages from Max. 
//These are the triggers for each shape sections. 
void oscEvent(OscMessage incomingMessage){
  if(incomingMessage.checkAddrPattern("/circletrigger")){
    circletrigger = incomingMessage.get(0).intValue();
  }
   if(incomingMessage.checkAddrPattern("/voice1trigger")){
    voice1trigger = incomingMessage.get(0).intValue();
  }
   if(incomingMessage.checkAddrPattern("/voice2trigger")){
    voice2trigger = incomingMessage.get(0).intValue();
  }
   if(incomingMessage.checkAddrPattern("/voice3trigger")){
    voice3trigger = incomingMessage.get(0).intValue();
  }
}
