import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.io.*; 
import java.io.FileReader; 
import java.time.*; 
import java.awt.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class KrakenTicker extends PApplet {

  //Need to find a way to close up resources properly


KrakenTickerWidget w1;
KrakenTickerWidget w2;
public void setup(){
    
 
    println("shetchopath"+sketchPath());
    w1 = new KrakenTickerWidget(sketchPath()+"/data/XXRPZUSD.txt");
    w2 = new KrakenTickerWidget(sketchPath()+"/data/XXBTZUSD.txt");
}
public void exit(){
 println("is hould stop");  super.exit();
}
public void draw(){
  
}
//Need to handle exception better



class CSVHandler { 
  String pathToCSV;
  BufferedReader reader;
  FileReader fReader;
  public CSVHandler(String path) {
    pathToCSV = path;
    try {
      fReader = new FileReader(pathToCSV);
      reader = new BufferedReader(fReader);
    }
    catch(Exception e) {
      println("FileNotFound");
    }
  }

  //returns "" when last entry is empty
  public String[] getLastRow() {
    // String [] lastRow = new String[9];

    String row="";
    String last="";
    try {    

      while ((row = reader.readLine()) != null)
      {
        last=row;
      }
      //lastRow = last.split(",");
    }  
    catch(Exception e) {
      println("Something went wrong"+e);
      println(pathToCSV);
    }
    return last.split(",");
  }
}
//Today's price start at 00:00:00 UTC
// Which is 7pm NYC

//getter and setters for local variables?

//Not intended to be deployable




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
public void settings(){
    fullScreen();
}
public void setup() {
  //size(960, 240);  
  surfaceWidth = 960;
  surfaceHeight = 240;
  iSurface();
  initStrings();
  tradePriceFontSize = 96;
  handler = new CSVHandler(fileName);
}
public void initStrings() {
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
public void iSurface() {
  surface.setSize(surfaceWidth, surfaceHeight);
  surface.setResizable(true);
  surface.setLocation(surfacePosX, surfacePosY);
}

//need a better way to substring, can be indexoutofbounds if string
//is shorter than 7 characters
public void drawAsk() {
  textAlign(RIGHT, TOP);
  textSize(48);
  text("ASK:"+askPrice.substring(0, 8), width, height/2);
  textSize(24);
  text("VOL: "+askVol, width, height/2+48);
}
//need a better way to substring, character 
//length might be smaller than 7
//askPrice,askVol
public void drawBid() {
  textSize(48);
  textAlign(LEFT, TOP);
  text("BID:"+bidPrice.substring(0, 8), 0, height/2);
  textSize(24);
  text("VOL: "+bidVol, 0, height/2+48);
}
public void drawLastTradePrice() {
  float newPrice = PApplet.parseFloat(lastTradePrice);
  float oldPrice = PApplet.parseFloat(oldTradePrice);
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
public void draw24Low() {
  textAlign(LEFT, TOP);
  textSize(48);
  text("LOW: "+last24Low, 0, 0);
}
public void draw24High() {
  textAlign(RIGHT, TOP);
  textSize(48);
  text("HIGH: "+last24High, width, 0);
}
//lastUpdatedTime,askPrice,askVol,bidPrice,bidVol,lastTradePrice,lastTradeVol, last24Low,last24High
public void updateStrings() {
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
public void draw() {
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
public void drawLastUpdatedTime() {
  textAlign(CENTER, BOTTOM);
  textSize(12);
  text("Last Updated: "+lastUpdatedTime, width/2, height);
}
public void updateSurface() {
  pmouse = mouse;
  mouse = MouseInfo.getPointerInfo().getLocation();
  if (mousePressed) {
    surfacePosX -= (pmouse.x - mouse.x);
    surfacePosY -= (pmouse.y - mouse.y);
    surface.setLocation(surfacePosX, surfacePosY);
  }
}
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "KrakenTicker" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
