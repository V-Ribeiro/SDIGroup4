import processing.video.*;
import gab.opencv.*;
int port = 8000;

PImage video; // received capture
PImage video2; // produced capture

ReceiverThread receiver;

PFont font;

//sender stuff
Movie movie;
String fileName = "parameters.txt";
String clientIP1;
int clientPort = 8000; 
DatagramSocket ds; 
long time;
float fR;
//

Capture cap;
ImgProcessing pro;
OpenCV cv ;

void setup()
{
  size(1280, 480);
  font = loadFont("MyriadPro-Regular-14.vlw");
  textFont(font, 14);
  textAlign(CENTER, CENTER);
  noFill();
  stroke(255);
  cv = new cv(this,640,480);
  pro = new ImgProcessing(cv);
  
  //initialize img
  video = createImage(640, 480, RGB);
  video2 = createImage(640, 480, RGB);
  
  //cap start
  cap = new Capture(this, 640,480);
  cap.start();
  //sender stuff
    String loadParameters[] = loadStrings(fileName);
  clientIP1 = loadParameters[0];
    try {
    ds = new DatagramSocket();
  } 
  catch (SocketException e) {
    e.printStackTrace();
  }
  movie = new Movie(this, "test.avi");
  movie.loop();
  //
  
  
  
  receiver = new ReceiverThread(port, 640, 480); // hc
  receiver.start();
}

void movieEvent(Movie m) {
  m.read();
    broadcast(m);
}

void captureEvent(Capture m)
{
  m.read();
  video2.copy(m, 0, 0, video2.width, video2.height, 0, 0, video2.width, video2.height);
}

void draw()
{
  if (receiver.available()) {
    video = receiver.getImage();
  }
  image(video, 0, 0);
  image(video2,640,0);
  
  text(receiver.getFr(), width / 2, height / 2);
}


  void broadcast(PImage img) {
    BufferedImage bimg = new BufferedImage( img.width, img.height, BufferedImage.TYPE_INT_RGB );
    bimg.setAccelerationPriority(1.);
    img.loadPixels();
    bimg.setRGB( 0, 0, img.width, img.height, img.pixels, 0, img.width);
    ByteArrayOutputStream baStream = new ByteArrayOutputStream();
    BufferedOutputStream bos = new BufferedOutputStream(baStream);
  
    try {
      ImageIO.write(bimg, "jpg", bos);
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
    byte[] packet = baStream.toByteArray();
    try {
      ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(clientIP1), clientPort));
    } 
    catch (Exception e) {
      e.printStackTrace();
    }
    fR = 1000 / (millis() - (float)time);
    time = millis();
  }