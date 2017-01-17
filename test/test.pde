import processing.video.*;
import gab.opencv.*;

//Mirror
Mirror realmirror;
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
float sensibility ;

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
  
  if (receiver.available()) { 
      try
      {
        other.copy(receiver.getImage(),0, 0, other.width, other.height, 0, 0, other.width, other.height); //deprecated
        realmirror.updateOther(receiver.getImage());
      }catch(Exception err)
      {
      err.getMessage();
      }   
  }
  image(other,0,0); // deprecated
  
    if(mirrorReady)
    {
    //put capture in mirror 
    realmirror.updateCapture(cap);
    //get movement
    realmirror.getMovement();
    mirror.copy(cap, 0, 0, mirror.width, mirror.height, 0, 0, mirror.width, mirror.height); // deprecated
    realmirror.process();
    realmirror.detectFace();
    //pro.getEdges("canny", mirror)
    image(realmirror.processed,640,0);
    }
    if(realmirror.FaceDetected)
    {
        //fill(240);
        //stroke(255,0,0);
        //rect( (float)pro.faceSquare.x + 640, (float)pro.faceSquare.y, (float)pro.faceSquare.getWidth() , (float)pro.faceSquare.getHeight() ); 
        float distance = abs((float)(realmirror.face.getCenterX()+640) - ball.xpos) + abs((float)realmirror.face.getCenterY() - ball.ypos);
        sensibility = distance / 1280;
        //println("face center" + realmirror.face.getCenterX() + "$$ sensibility:" + sensibility );
        ball.update(realmirror.face.getLocation(), realmirror.avgMotion);
    }
    if(realmirror.avgMotion > 25)
    {
      println("Found Motion");
    }
  ball.draw();
  
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