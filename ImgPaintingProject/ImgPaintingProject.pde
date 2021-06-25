/*
============================================================
Music Title: The 5-minute hypothesis (Sekai Gofunmae Kasetsu)
Original Composed by UK Rampage

Transformed into Midi file by ayuokeuoni (Youtube Link: https://youtu.be/qaeWjQ6fcc8)
Photo by Evgeni Tcherkasski on Unsplash (Unsplash Link: https://unsplash.com/@evgenit)
Transformed to Processing Project by AlpacaParker4592 (Github Link: https://github.com/AlpacaParker4592)
============================================================
*/

import ddf.minim.analysis.*;
import ddf.minim.*;


Minim minim;
AudioPlayer musicC,musicD,musicE,musicV,musicM;
FFT fftLinC,fftLinD,fftLinE,fftLinV;
PImage[] road = new PImage[3],roadWithoutStar = new PImage[3],roadPaint = new PImage[3];
PImage[] funcPaint = new PImage[1824];
PImage copyImage;
PImage transparentImage;
int sceneNum = 0;

float rotateAngle = -0.663;
float maxTrans = 127;
float maxTransLine=maxTrans;

float imageTrans = 120;
float ampMulti = height;
float spectrumScaleC=2, spectrumScaleD=6, spectrumScaleE=8, spectrumScaleV=1.3;
float scaleFactorC=1, scaleFactorD=1, scaleFactorE=1, scaleFactorV=1;

float volumeDiff = 2;
float maxVolume = 40;
float minVolume = -40;
float volumeC=0, volumeD=0, volumeE=0, volumeV=0;

PFont instInfo;
int fontSize = 30;

float executeTime;

PImage whiteImg;

void setup()
{
  frameRate(60);
  size(1024, 800);
  whiteImg = createImage(width, height, RGB);
  whiteImg.loadPixels();
  for (int i = 0; i < whiteImg.pixels.length; i++) {
    whiteImg.pixels[i] = color(255, 255, 255); 
  }
  whiteImg.updatePixels();
  image(whiteImg, 0, 0);
  
  transparentImage = loadImage("transparent.png");
  transparentImage.resize(1024,800);
  road[0] = loadImage("roadAtNight.jpg");
  roadWithoutStar[0] = loadImage("roadAtNightWithoutStar.jpg");
  roadPaint[0] = loadImage("roadAtNightWithoutStarPaint.jpg");
  road[0].resize(1024,800);
  roadWithoutStar[0].resize(1024,800);
  roadPaint[0].resize(1024,800);
  road[1] = sketch(road[0]);
  roadWithoutStar[1] = sketch(roadWithoutStar[0]);
  roadPaint[1] = sketch(roadPaint[0]);
  road[2] = road[0].copy();road[2].filter(GRAY);
  roadWithoutStar[2] = roadWithoutStar[0].copy();roadWithoutStar[2].filter(GRAY);
  roadPaint[2] = roadPaint[0].copy();roadPaint[2].filter(GRAY);
  
  for(int i=1; i<road.length;i++){
    road[i].resize(1024,800);
    roadWithoutStar[i].resize(1024,800);
    roadPaint[i].resize(1024,800);
  }
  
  for(int i=0; i<brush.length;i++){
    brush[i] = loadImage("brush1.png");
    int brushSize = (int)random(100,250);
    brush[i].resize(brushSize,brushSize);
  }
  for(int i=0; i<brushL.length;i++){
    int randomBrush = (int)random(1,7);
    switch(randomBrush){
      case 1:
        brushL[i] = loadImage("lbrush1.png");break;
      case 2:
        brushL[i] = loadImage("lbrush2.png");break;
      case 3:
        brushL[i] = loadImage("lbrush3.png");break;
      case 4:
        brushL[i] = loadImage("lbrush4.png");break;
      case 5:
        brushL[i] = loadImage("lbrush5.png");break;
      default:
        brushL[i] = loadImage("lbrush6.png");break;
    }
    float brushSizeFact = random(0.5,1.5);
    brushL[i].resize((int)(brushL[i].width*brushSizeFact),(int)(brushL[i].height*brushSizeFact));
  }
  
  minim = new Minim(this);
  musicC = minim.loadFile("The_5_minute_hypothesis_Classic.mp3", 2048);
  musicD = minim.loadFile("The_5_minute_hypothesis_Drum.mp3", 2048);
  musicE = minim.loadFile("The_5_minute_hypothesis_Electrics.mp3", 2048);
  musicV = minim.loadFile("The_5_minute_hypothesis_Vocal.mp3", 2048);
  musicM = minim.loadFile("The_5_minute_hypothesis_Mute.mp3", 2048);
  musicC.play();
  musicD.play();
  musicE.play();
  musicV.play();
  musicM.play();
  
  int lineCount = 50;
  
  fftLinC = new FFT( musicC.bufferSize(), musicC.sampleRate() );
  fftLinD = new FFT( musicD.bufferSize(), musicD.sampleRate() );
  fftLinE = new FFT( musicE.bufferSize(), musicE.sampleRate() );
  fftLinV = new FFT( musicV.bufferSize(), musicV.sampleRate() );
  fftLinC.linAverages( lineCount );
  fftLinD.linAverages( lineCount );
  fftLinE.linAverages( lineCount );
  fftLinV.linAverages( lineCount );
  rectMode(CORNERS);
  
  instInfo = createFont("BebasNeue.ttf",fontSize);
  textAlign(RIGHT);

  executeTime = millis();
}

void draw()
{
  float startWidth = -width/2;
  if(imageTrans>255){imageTrans=255;}
  else if(imageTrans<0){imageTrans=0;}
  if(maxTrans>255){maxTrans=255;}
  else if(maxTrans<0){maxTrans=0;}
  if(maxTransLine>255){maxTransLine=255;}
  else if(maxTransLine<0){maxTransLine=0;}
  
  background(0,255);
  
  tint(255, imageTrans);
  copyImage = new PImage();
  fade(whiteImg,15,17.5,executeTime);
  brushL(roadPaint[2],18,30,executeTime,musicC,fftLinC,46,0,0); // 0L
  brush(roadPaint[2],30,63,executeTime,musicV,fftLinV,25,0,0); // 0
  fadeUL(roadPaint[2],66,77,executeTime, sceneNum);
  brushL(roadWithoutStar[1],77,91.5,executeTime,musicC,fftLinC,17,1,1); // 1L
  fade(roadWithoutStar[1],88,91.5,executeTime);
  brush(roadWithoutStar[2],91.5,110,executeTime,musicV,fftLinV,18,1,0); // 1
  fade(roadWithoutStar[1],110,129,executeTime);
  brushL(roadWithoutStar[0],130,146,executeTime,musicV,fftLinV,0.3,2,0); // 2L
  fade(whiteImg,145,147,executeTime);
  brushL(roadPaint[0],147,169,executeTime,musicC,fftLinC,2,3,1); // 3L
  brush(roadPaint[0],147,169,executeTime,musicV,fftLinV,2,2,1); // 2
  brush(roadPaint[0],172,184,executeTime,musicE,fftLinE,0,3,1); // 3
  fade(roadPaint[0],182,184,executeTime);
  fadeUL(roadWithoutStar[0],184,195,executeTime, sceneNum);
  brushL(roadPaint[1],195,210,executeTime,musicC,fftLinC,2,4,0); // 4L
  fade(roadPaint[1],209,212,executeTime);
  brushL(road[0],212.8,227.5,executeTime,musicV,fftLinV,0,5,1); // 5L
  fade(roadPaint[1],225,227,executeTime);
  brush(road[0],227,247,executeTime,musicV,fftLinV,17.5,4,0); // 4
  brushL(road[0],253,265,executeTime,musicV,fftLinV,0,6,0); // 6L
  fade(road[0],264,264.5,executeTime);
  brushL(road[1],264.7,272.3,executeTime,musicV,fftLinV,0,7,0); // 7L
  fade(road[0],271.8,272.3,executeTime);
  brushL(road[1],272.4,279.5,executeTime,musicV,fftLinV,0,8,0); // 8L
  fade(road[0],279,279.5,executeTime);
  brushL(road[1],279.6,286,executeTime,musicV,fftLinV,0,9,1); // 9L
  fade(road[0],285.5,286,executeTime);
  brushL(road[1],279.6,294,executeTime,musicV,fftLinV,5,10,1); // 10L
  fade(road[0],294,297,executeTime);
  
  
  
  textFont(instInfo);
  float fontTrans = maxTrans*3;
  if(fontTrans>255){fontTrans=255;}
  fill(200, 255, 255, fontTrans); text("Drum_set: ",width-130,height-fontSize*3*7/6-20);
  fill(255, 255, 200, fontTrans); text("Harmonica: ",width-130,height-fontSize*2*7/6-20);
  fill(255, 200, 255, fontTrans); text("Piano&Violin: ",width-130,height-fontSize*7/6-20);
  fill(200, 255, 200, fontTrans); text("E.Instruments: ",width-130,height-20);
  fill(255, 255, 255, fontTrans);
  if(volumeD>=0){text("+"+String.valueOf((int)volumeD)+".00 dB",width-20,height-fontSize*3*7/6-20);}
  else{text(String.valueOf((int)volumeD)+".00 dB",width-20,height-fontSize*3*7/6-20);}
  if(volumeV>=0){text("+"+String.valueOf((int)volumeV)+".00 dB",width-20,height-fontSize*2*7/6-20);}
  else{text(String.valueOf((int)volumeV)+".00 dB",width-20,height-fontSize*2*7/6-20);}
  if(volumeC>=0){text("+"+String.valueOf((int)volumeC)+".00 dB",width-20,height-fontSize*7/6-20);}
  else{text(String.valueOf((int)volumeC)+".00 dB",width-20,height-fontSize*7/6-20);}
  if(volumeE>=0){text("+"+String.valueOf((int)volumeE)+".00 dB",width-20,height-20);}
  else{text(String.valueOf((int)volumeE)+".00 dB",width-20,height-20);}
  
  translate(width/2,height/2);
  rotate(rotateAngle);
  float diff;
  float transparency;
  //background(0);
  
  strokeWeight(3);
  stroke(255, maxTransLine);
  line(startWidth/32,0,(width+startWidth)/32,0);
  strokeWeight(1);
  line(startWidth/48,-height/128,startWidth/48,height/128);
  line((width+startWidth)/48,-height/128,(width+startWidth)/48,height/128);
  strokeWeight(3);
  line(startWidth,-height/4,width+startWidth,-height/4);
  line(startWidth,height/4,width+startWidth,height/4);
  fftLinC.forward( musicC.mix );
  fftLinD.forward( musicD.mix );
  fftLinE.forward( musicE.mix );
  fftLinV.forward( musicV.mix );
  
  //noStroke();
  strokeWeight(1);
  {//Drum
    stroke(200, 255, 255, maxTrans);
    int w = int( width/fftLinD.avgSize() );
    for(int i = 0; i < fftLinD.avgSize(); i++){
      diff = (mouseX - i*w)*6;
      transparency= (511-(abs(-diff +startWidth)+abs(diff +startWidth))/width*127)*maxTrans/255;
      if(transparency<=0){transparency=0;}
      else if(transparency>maxTrans){transparency=maxTrans;}
      fill(200, 255, 255, transparency);
      float scaleD = spectrumScaleD*scaleFactorD;
      rect((i*w)+startWidth+1.5, -height/4, i*w + w+startWidth-1.5, -height/4 - fftLinD.getBand(i)*scaleD);
    }
  }
  {//Vocal
    stroke(255, 255, 200, maxTrans);
    int w = int( height/fftLinV.avgSize() );
    for(int i = 0; i < fftLinV.avgSize(); i++){
      diff = (mouseX - i*w)*6;
      transparency= (511-(abs(-diff +startWidth)+abs(diff +startWidth))/width*127)*maxTrans/255;
      if(transparency<=0){transparency=0;}
      else if(transparency>maxTrans){transparency=maxTrans;}
      fill(255, 255, 200, transparency);
      float scaleV = spectrumScaleV*scaleFactorV;
      rect(i*w+startWidth+1.5, - height/4, i*w + w+startWidth-1.5, - height/4 + fftLinV.getBand(i)*scaleV);
    }
  }
  {//Classic
    stroke(255, 200, 255, maxTrans);
    int w = int( width/fftLinC.avgSize() );
    for(int i = 0; i < fftLinC.avgSize(); i++){
      diff = (mouseX - i*w)*6;
      transparency= (511-(abs(-diff +startWidth)+abs(diff +startWidth))/width*127)*maxTrans/255;
      if(transparency<=0){transparency=0;}
      else if(transparency>maxTrans){transparency=maxTrans;}
      fill(255, 200, 255, transparency);
      float scaleC = spectrumScaleC*scaleFactorC;
      rect(i*w+startWidth+1.5, height/4, i*w+w+startWidth-1.5, height/4 - fftLinC.getBand(i)*scaleC);
    }
  }
  {//Electrics
    stroke(200, 255, 200, maxTrans);
    int w = int( width/fftLinE.avgSize() );
    for(int i = 0; i < fftLinE.avgSize(); i++){
      diff = (mouseX - i*w)*6;
      transparency= (511-(abs(-diff +startWidth)+abs(diff +startWidth))/width*127)*maxTrans/255;
      if(transparency<=0){transparency=0;}
      else if(transparency>maxTrans){transparency=maxTrans;}
      fill(200, 255, 200, transparency);
      float scaleE = spectrumScaleE*scaleFactorE;
      rect(i*w+startWidth+1.5, height/4, i*w + w+startWidth-1.5, height/4 + fftLinE.getBand(i)*scaleE);
    }
  }
}

void mouseWheel(MouseEvent event){
  float e = event.getCount();
  if(e>0){maxTrans-=10;maxTransLine-=10;}
  else if(e<0){maxTrans+=10;maxTransLine+=10;}
}

void mouseClicked() {
  if(mouseY<tan(rotateAngle)*mouseX+545){
    if (mouseButton == LEFT) {
      volumeD+=volumeDiff;
      if(volumeD>maxVolume){volumeD=maxVolume;}
      musicD.setGain(volumeD);
    }
    else if (mouseButton == RIGHT) {
      volumeD-=volumeDiff;
      if(volumeD<minVolume){volumeD=minVolume;}
      musicD.setGain(volumeD);
    }
    scaleFactorD=(1-volumeD/minVolume);
  }
  else if(mouseY<tan(rotateAngle)*mouseX+800){
    if (mouseButton == LEFT) {
      volumeV+=volumeDiff;
      if(volumeV>maxVolume){volumeV=maxVolume;}
      musicV.setGain(volumeV);
    }
    else if (mouseButton == RIGHT) {
      volumeV-=volumeDiff;
      if(volumeV<minVolume){volumeV=minVolume;}
      musicV.setGain(volumeV);
    }
    scaleFactorV=(1-volumeV/minVolume);
  }
  else if(mouseY<tan(rotateAngle)*mouseX+1055){
    if (mouseButton == LEFT) {
      volumeC+=volumeDiff;
      if(volumeC>maxVolume){volumeC=maxVolume;}
      musicC.setGain(volumeC);
    }
    else if (mouseButton == RIGHT) {
      volumeC-=volumeDiff;
      if(volumeC<minVolume){volumeC=minVolume;}
      musicC.setGain(volumeC);
    }
    scaleFactorC=(1-volumeC/minVolume);
  }
  else{
    if (mouseButton == LEFT) {
      volumeE+=volumeDiff;
      if(volumeE>maxVolume){volumeE=maxVolume;}
      musicE.setGain(volumeE);
    }
    else if (mouseButton == RIGHT) {
      volumeE-=volumeDiff;
      if(volumeE<minVolume){volumeE=minVolume;}
      musicE.setGain(volumeE);
    }
    scaleFactorE=(1-volumeE/minVolume);
  }
}
