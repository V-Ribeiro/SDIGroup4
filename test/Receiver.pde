import java.awt.image.*; 
import javax.imageio.*;
import java.net.*;
import java.io.*;



class ReceiverThread extends Thread {

  int port;
  DatagramSocket ds; 
  byte[] buffer = new byte[65536]; 

  boolean running;
  boolean available;

  PImage img;
  
  long time;
  float fR;

  ReceiverThread (int port, int w, int h) {
    
    this.port = port;
    img = createImage(w, h, RGB);
    running = false;
    available = true;

    try {
      ds = new DatagramSocket(port);
    } catch (SocketException e) {
      e.printStackTrace();
    }
  }

  PImage getImage() {
    available = false;
    return img;
  }

  boolean available() {
    return available;
  }
  
  float getFr() {
    return fR;
  }

  void start () {
    running = true;
    super.start();
  }

  void run () {
    while (running) {
      checkForImage();
      available = true;
    }
  }

  void checkForImage() {
    DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
    try {
      ds.receive(p);
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    byte[] data = p.getData();
    ByteArrayInputStream bais = new ByteArrayInputStream( data );

    img.loadPixels();
    try {
      BufferedImage bimg = ImageIO.read(bais);
      bimg.getRGB(0, 0, img.width, img.height, img.pixels, 0, img.width);
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    img.updatePixels();
    
    fR = 1000 / (millis() - (float)time);
    time = millis();
  }

  void quit() {
    running = false;
    interrupt();
  }
}