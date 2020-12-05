 /*
 * @author      LuisMQuinones
 * @modified    November 22, 2020
 */


import java.io.*;
KrakenTickerWidget w1;
KrakenTickerWidget w2;
void setup(){
    size(100,100);
 
    println("shetchopath"+sketchPath());
    w1 = new KrakenTickerWidget("/Users/luisquinones/Desktop/KrakenTicker/data/XXBTZUSD.csv");
   // w2 = new KrakenTickerWidget(sketchPath()+"/data/XXBTZUSD.txt");
}
void exit(){
 println("is hould stop");  super.exit();
}
void draw(){
  
}
