import java.net.*;
import java.io.*;


////message type 1 : face at : x , y , w , h
//// movement other


class MessageReceiverThread extends Thread {

  int port;
  DatagramSocket ds; 
  byte[] buffer = new byte[65536]; 

  boolean running;
  boolean available;

  Message msg;
  
  long time;
  float fR;

  MessageReceiverThread (int port) {
    
    this.port = port;
    running = false;
    available = true;

    try {
      ds = new DatagramSocket(port);
    } catch (SocketException e) {
      e.printStackTrace();
    }
  }

  Message getMessage() {
    available = false;
    return msg;
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
      checkForMessage();
      available = true;
    }
  }

  void checkForMessage() {
    DatagramPacket p = new DatagramPacket(buffer, buffer.length); 
    try {
      ds.receive(p);
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    byte[] data = p.getData();
    //ByteArrayInputStream bais = new ByteArrayInputStream( data );

    
    fR = 1000 / (millis() - (float)time);
    time = millis();
  }

  void quit() {
    running = false;
    interrupt();
  }
}