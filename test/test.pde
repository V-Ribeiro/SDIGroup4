import processing.video.*;
import gab.opencv.*;

//Mirror
Mirror realmirror;
PFont font;
int port = 8000;
PImage mirror;
Capture cap;
ImgProcessing pro;
OpenCV cv ;
Boolean mirrorReady = false;

//mirror must send and receive
Movie movie;
String fileName = "parameters.txt";
String clientIP1;
int clientPort = 8000; 
DatagramSocket ds; 
long time;
float fR;
//
//Ball stuff
Ball ball;

// Other images 
PImage other;
ReceiverThread receiver;




void setup()
{
  size(1280, 960);

  ball = new Ball();

  cv = new OpenCV(this,640,480);
  cv.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  
  pro = new ImgProcessing(cv);
  //mirror init
  realmirror = new Mirror(pro);
  //initialize img
  other = createImage(640, 480, RGB); //deprecated
  mirror = createImage(640, 480, RGB); //deprecated
  
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

  // start movie
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
  mirrorReady = false;
  m.read();
  mirrorReady = true;
}

void draw()
{
  ball = new Ball();
  if (receiver.available()) { 
      try
      {
        other.copy(receiver.getImage(),0, 0, other.width, other.height, 0, 0, other.width, other.height);
        realmirror.updateOther(receiver.getImage());
       
      }catch(Exception err)
      {
      err.getMessage();
      }
        
  }
  image(other,0,0);
  
    if(mirrorReady)
    {
    //put capture in mirror 
    realmirror.updateCapture(cap);
    realmirror.tool.getMotion(realmirror.previous,realmirror.capture);
    mirror.copy(cap, 0, 0, mirror.width, mirror.height, 0, 0, mirror.width, mirror.height);
    realmirror.process();
    pro.detect(mirror);
    //pro.getEdges("canny", mirror)
    image(realmirror.processed,640,0);
    }
    if(pro.faceDetected)
    {
        //fill(240);
        //stroke(255,0,0);
        //rect( (float)pro.faceSquare.x + 640, (float)pro.faceSquare.y, (float)pro.faceSquare.getWidth() , (float)pro.faceSquare.getHeight() ); 
        println("face center" + pro.faceSquare.getCenterX());
    }
  ball.draw();
  
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