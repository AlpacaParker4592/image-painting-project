PImage sketch(PImage origin){
  PImage dest=createImage(origin.width, origin.height, RGB);
  origin.loadPixels();
  dest.loadPixels();
  
  for (int x = 1; x < width; x++ ) {
    for (int y = 0; y < height; y++ ) {
      int loc = x + y*origin.width;
      color pix = origin.pixels[loc];
      
      int leftLoc = (x - 1) + y*origin.width;
      color leftPix = origin.pixels[leftLoc];
      float diff = 255-abs(brightness(pix) - brightness(leftPix));
      dest.pixels[loc] = color(diff);
    }
  }
  
  return dest;
}

void fade(PImage afterImage, float startTime, float endTime, float exeTime){
  float curTime = (millis()-exeTime)/1000;
  if(endTime>startTime && curTime>=startTime){
    if(curTime>=endTime){curTime=endTime;}
    float colorTrans = (curTime-startTime)/(endTime-startTime) * imageTrans;
    float trans = (curTime-startTime)/(endTime-startTime) * 255;
    tint(colorTrans, trans);
    funcPaint[0] = afterImage;
    image(afterImage,0,0);
  }
}

void fadeUL(PImage afterImage, float startTime, float endTime, float exeTime, int scene){
  //PImage result = createImage(width, height, RGB);
  PImage result = transparentImage.copy();
  float curTime = (millis()-exeTime)/1000;
  color pix;
  int loc;
  if(endTime>startTime && curTime>=startTime){
    tint(imageTrans);
    if(curTime>=endTime){
      funcPaint[0] = afterImage.copy();
      scene = 0;
      funcPaint[0] = afterImage;
      image(afterImage,0,0);
      return;
    }
    result.loadPixels();
    int n = 0;
    float blockTri = (curTime-startTime)/(endTime-startTime)*(height+width);
    for(int x=0;x<blockTri;x++){
      for(int y=0;y<blockTri-n;y++){
        if(y<height && x<width){
          loc = x + y*width;
          pix = afterImage.pixels[loc];
          result.pixels[loc] = color(pix);
        }
      }
      n++;
    }
    result.updatePixels();
    funcPaint[scene] = result;
    image(result,0,0);
    scene+=1;
  }
}

int completedNum = 0;
boolean isFuncCompleted = true;
int prevFreq = 0;
int purSeq=0;
int brushCount = 150;
PImage[] brush = new PImage[brushCount];
PImage[] afterBrush = new PImage[brushCount];
int[] arrX = new int[brushCount];
int[] arrY = new int[brushCount];
int brushTrans = 150;

int brushSeq = 0;
void brush(PImage afterImage, float startTime, float endTime, float exeTime, AudioPlayer music, FFT fftLine, float extraTime, int completeNumber, int randMode){
  if(completeNumber != completedNum){return;}
  float curTime = (millis()-exeTime)/1000;
  if(endTime>startTime && curTime>=startTime){
    tint(brushTrans);
    float maxAmp = 0;
    int curFreq = 0;
    if(curTime>=endTime){
      if(curTime>=endTime+extraTime){isFuncCompleted = true; completedNum++; return;}
      for(int i=0;i<purSeq;i++){
        if(randMode == 1){
          switch(i%4){
            case 0: tint(255,100,100,brushTrans); break;
            case 1: tint(255,255,100,brushTrans); break;
            case 2: tint(100,100,255,brushTrans); break;
            default: tint(100,255,100, brushTrans); break;
          }
        }
        image(afterBrush[i],arrX[i],arrY[i]);
      }
      return;
    }
    
    if(isFuncCompleted){brushSeq=0; isFuncCompleted=false;}
    fftLine.forward( music.mix );
    for(int i=0;i<fftLine.avgSize();i++){
      if(maxAmp<fftLine.getBand(i)){
        maxAmp = fftLine.getBand(i);
        curFreq = i;
      }
    }
    if(prevFreq != curFreq && maxAmp>=50 && brushSeq < brush.length){
      arrX[brushSeq] = (int)random(-brush[brushSeq].width,width);
      arrY[brushSeq] = (int)random(-brush[brushSeq].height,height);
      //PImage result = createImage(brush[brushSeq].width,brush[brushSeq].height,RGB);
      PImage result = brush[brushSeq].copy();
      result.loadPixels();
      //for(int i=0;i<result.pixels.length;i++){result.pixels[i]=color(0,0,0,255);}
      //if(isSeqComplete){purSeq = brushCount;}
      if(purSeq>=brush.length){purSeq = brush.length-1;}//check
      else{purSeq = brushSeq;}
      for(int x=0;x<brush[brushSeq].width;x++){for(int y=0;y<brush[brushSeq].height;y++){
        int afterX = x+arrX[brushSeq];
        int afterY = y+arrY[brushSeq];
        if(x>=0 && y>=0 && afterX<width && afterY<height){
          int loc = x + y*brush[brushSeq].width;
          int afterLoc = afterX + afterY*width;
          color bpix = brush[brushSeq].pixels[loc];
          if(bpix!=0 && afterLoc>=0){result.pixels[loc] = color(afterImage.pixels[afterLoc],150);}
        }
      }}
      result.updatePixels();
      //blend(result,0,0,width,height,0,0,width,height,DARKEST);
      afterBrush[brushSeq] = result;
      brushSeq++;
    }
    //if(purSeq==brush.length){purSeq=brush.length-1;}
    for(int i=0;i<purSeq;i++){
      if(randMode == 1){
          switch(i%4){
            case 0: tint(255,100,100,brushTrans); break;
            case 1: tint(255,255,100,brushTrans); break;
            case 2: tint(100,100,255,brushTrans); break;
            default: tint(100,255,100, brushTrans); break;
          }
        }
      image(afterBrush[i],arrX[i],arrY[i]);
    }
    
    prevFreq = curFreq;
  }
  tint(imageTrans);
}

int completedNumL = 0;
boolean isFuncCompletedL = true;
int prevFreqL = 0;
int purSeqL=0;
PImage[] brushL = new PImage[brushCount];
PImage[] afterBrushL = new PImage[brushCount];
int[] arrXL = new int[brushCount];
int[] arrYL = new int[brushCount];

int brushSeqL = 0;
void brushL(PImage afterImage, float startTime, float endTime, float exeTime, AudioPlayer music, FFT fftLine, float extraTime, int completeNumber, int randMode){

  if(completeNumber != completedNumL){return;}
  float curTime = (millis()-exeTime)/1000;
  if(endTime>startTime && curTime>=startTime){
    tint(brushTrans);
    float maxAmp = 0;
    int curFreq = 0;
    if(curTime>=endTime){
      if(curTime>=endTime+extraTime){isFuncCompletedL = true; completedNumL++; return;}
      for(int i=0;i<purSeqL;i++){
        if(randMode == 1){
          switch(i%4){
            case 0: tint(255,100,100,brushTrans); break;
            case 1: tint(255,255,100,brushTrans); break;
            case 2: tint(100,100,255,brushTrans); break;
            default: tint(100,255,100, brushTrans); break;
          }
        }
        image(afterBrushL[i],arrXL[i],arrYL[i]);
      }
      return;
    }
    
    if(isFuncCompletedL){brushSeqL=0; isFuncCompletedL=false;}
    fftLine.forward( music.mix );
    for(int i=0;i<fftLine.avgSize();i++){
      if(maxAmp<fftLine.getBand(i)){
        maxAmp = fftLine.getBand(i);
        curFreq = i;
      }
    }
    if(prevFreq != curFreq && maxAmp>=50 && brushSeqL < brushL.length){
      arrXL[brushSeqL] = (int)(random(-brushL[brushSeqL].width,width));
      arrYL[brushSeqL] = (int)(random(-brushL[brushSeqL].height,height));
      //PImage result = createImage(brush[brushSeq].width,brush[brushSeq].height,RGB);
      PImage result = brushL[brushSeqL].copy();
      result.loadPixels();
      //6for(int i=0;i<result.pixels.length;i++){result.pixels[i]=color(0,0,0,255);}
      //if(isSeqCompleteL){purSeqL = brushCount;}
      //else{purSeqL = brushSeqL;}
      if(purSeqL>=brushL.length){purSeqL = brushL.length-1;}//check
      else{purSeqL = brushSeqL;}
      for(int x=0;x<brushL[brushSeqL].width;x++){for(int y=0;y<brushL[brushSeqL].height;y++){
        int afterX = x+arrXL[brushSeqL];
        int afterY = y+arrYL[brushSeqL];
        if(x>=0 && y>=0 && afterX<width && afterY<height){
          int loc = x + y*brushL[brushSeqL].width;
          int afterLoc = afterX + afterY*width;
          color bpix = brushL[brushSeqL].pixels[loc];
          if(bpix!=0 && afterLoc>=0){result.pixels[loc] = color(afterImage.pixels[afterLoc],150);}
        }
      }}
      result.updatePixels();
      //blend(result,0,0,width,height,0,0,width,height,DARKEST);
      afterBrushL[brushSeqL] = result;
      brushSeqL++;

    }
    for(int i=0;i<purSeqL;i++){
      if(randMode == 1){
          switch(i%4){
            case 0: tint(255,100,100,brushTrans); break;
            case 1: tint(255,255,100,brushTrans); break;
            case 2: tint(100,100,255,brushTrans); break;
            default: tint(100,255,100, brushTrans); break;
          }
        }
      image(afterBrushL[i],arrXL[i],arrYL[i]);
    }
    prevFreq = curFreq;
  }
  
  tint(imageTrans);
}
