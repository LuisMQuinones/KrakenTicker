  //Need to find a way to close up resources properly

import java.io.*;
KrakenTickerWidget w1;
KrakenTickerWidget w2;
void setup(){
    size(100,100);
 
    println("shetchopath"+sketchPath());
    w1 = new KrakenTickerWidget(sketchPath()+"/data/XXRPZUSD.txt");
    w2 = new KrakenTickerWidget(sketchPath()+"/data/XXBTZUSD.txt");
}
void exit(){
 println("is hould stop");  super.exit();
}
void draw(){
  
}
