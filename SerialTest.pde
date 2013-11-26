import processing.serial.*;

Serial port;
PFont font;
long start = 0;
long bytesCount = 0;
int avgIndex = 0;
int avgValue = 0;
String avgStr = "";

void setup() {
  size(400,200);
  font = createFont("Monospaced", 16, true);
  port = new Serial(this, "COM17", 115200);
}

void draw() {
  
  background(255);
  textFont(font);       
  fill(0);
  
  if (port.available() > 0) {
    if (start == 0) {
      start = (System.currentTimeMillis() - 1);
    }
    bytesCount += port.readBytes(new byte[port.available()]);
  }
  
  long timeSpent = (System.currentTimeMillis() - start);
  long current = (bytesCount*10)/timeSpent*1000;//bytesCount*10 because we have 8-bits per byte, 1 stop-bit and 1 start-bit
  avgValue += current;
  avgIndex++;
  
  if (avgIndex == 99) {
    avgStr = ("" + avgValue/100);
    avgValue = 0;
    avgIndex = 0;
  }
  
  int hh = (int)((timeSpent/(1000*60*60)) % 24);
  int mm = (int)((timeSpent/(1000*60)) % 60);
  int ss = (int)((timeSpent/1000) % 60);
  
  text("cur rate: " + current, 10, height/4 - 16);
  text("avg rate: " + avgStr, 10, height/2 - 16);
  text("Kbytes: " + bytesCount/1024 + " (bytes: " + bytesCount + ")", 10, height*3/4 - 16);
  text("Time spent: " + String.format("%02d:%02d:%02d", hh, mm, ss), 10, height - 16);
}
