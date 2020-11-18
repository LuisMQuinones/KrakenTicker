//Today's price start at 00:00:00 UTC
// Which is 7pm NYC

//getter and setters for local variables?

//Not intended to be deployable

import java.time.*;
import java.awt.*;

class KrakenTickerWidget extends PApplet{
String fileName;
int surfacePosX = 0;
int surfacePosY = 00;
Point mouse = new Point(0, 0);
Point pmouse = new Point(0, 0);
int surfaceWidth, surfaceHeight;


float tradePriceFontSize;
String todayOpenPrice
  , askPrice, askVol
  , bidPrice, bidVol
  , lastTradePrice, lastTradeVol //
  , last24hourVolume
  , last24hourVolumeWeightAverage
  , last24NumberOfTrades
  , last24Low
  , last24High;
String lastUpdatedTime = LocalTime.now().toString();
int oldWidth, oldHeight;
boolean locked;

String oldTradePrice;

CSVHandler handler;


public  KrakenTickerWidget(String fName){
   super();
    PApplet.runSketch(new String[]{this.getClass().getName()}, this);
    fileName  = fName; 
}
void settings(){
    fullScreen();
}
void setup() {
  //size(960, 240);  
  surfaceWidth = 960;
  surfaceHeight = 240;
  iSurface();
  initStrings();
  tradePriceFontSize = 96;
  handler = new CSVHandler(fileName);
}
void initStrings() {
  todayOpenPrice = "11111111";
  askPrice = "1111111111";
  askVol = "0.01111";
  bidPrice = "11111111";
  bidVol= "0.011";
  lastTradePrice = "1111111";
  lastTradeVol = "0.110";
  last24hourVolume = "111";
  last24hourVolumeWeightAverage = "111111111";
  last24NumberOfTrades = "111111111";
  last24Low = "11111111111";
  last24High = "999911199";
  oldTradePrice = "11111";
}
void iSurface() {
  surface.setSize(surfaceWidth, surfaceHeight);
  surface.setResizable(true);
  surface.setLocation(surfacePosX, surfacePosY);
}

//need a better way to substring, can be indexoutofbounds if string
//is shorter than 7 characters
void drawAsk() {
  textAlign(RIGHT, TOP);
  textSize(48);
  text("ASK:"+askPrice.substring(0, 8), width, height/2);
  textSize(24);
  text("VOL: "+askVol, width, height/2+48);
}
//need a better way to substring, character 
//length might be smaller than 7
//askPrice,askVol
void drawBid() {
  textSize(48);
  textAlign(LEFT, TOP);
  text("BID:"+bidPrice.substring(0, 8), 0, height/2);
  textSize(24);
  text("VOL: "+bidVol, 0, height/2+48);
}
void drawLastTradePrice() {
  float newPrice = float(lastTradePrice);
  float oldPrice = float(oldTradePrice);
  float diff = newPrice-oldPrice;
  oldTradePrice = lastTradePrice;
  if (diff<0) {
    fill(255, 0, 0);
  } else if (diff>0) {
    fill(0, 255, 0);
  }
  textAlign(CENTER, TOP);
  textSize(tradePriceFontSize);
  text(lastTradePrice, width/2, height/2-textAscent());
  //text(lastTradePrice.substring(0, 8), width/2, height/2-textAscent());
  textSize(48);
  textAlign(CENTER, TOP);
  text(lastTradeVol.substring(0, 8), width/2, height/2);
}
void draw24Low() {
  textAlign(LEFT, TOP);
  textSize(48);
  text("LOW: "+last24Low, 0, 0);
}
void draw24High() {
  textAlign(RIGHT, TOP);
  textSize(48);
  text("HIGH: "+last24High, width, 0);
}
//lastUpdatedTime,askPrice,askVol,bidPrice,bidVol,lastTradePrice,lastTradeVol, last24Low,last24High
void updateStrings() {
  String [] lst= handler.getLastRow(); 
  if (lst.length==9) {
    lastUpdatedTime = lst[0];
    askPrice = lst[1];
    askVol = lst[2];
    bidPrice = lst[3];
    bidVol = lst[4];
    lastTradePrice = lst[5];
    lastTradeVol = lst[6];
    last24Low = lst[7];
    last24High = lst[8];
  }
  
}
void draw() {
  updateSurface();
  //background(150);
  background(0);
  line(0, 0, width, height);
  line(0, height, width, 0);
  updateStrings();
  drawLastTradePrice();
  drawAsk();
  drawBid();
  drawLastUpdatedTime();
  draw24Low();
  draw24High();
}
void drawLastUpdatedTime() {
  textAlign(CENTER, BOTTOM);
  textSize(12);
  text("Last Updated: "+lastUpdatedTime, width/2, height);
}
void updateSurface() {
  pmouse = mouse;
  mouse = MouseInfo.getPointerInfo().getLocation();
  if (mousePressed) {
    surfacePosX -= (pmouse.x - mouse.x);
    surfacePosY -= (pmouse.y - mouse.y);
    surface.setLocation(surfacePosX, surfacePosY);
  }
}
}
