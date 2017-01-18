import processing.video.*;
import gab.opencv.*;

//Mirror
Mirror realmirror;
int port = 8000;  // where to receive
int messagePort = 8002;  // where to receive
PImage mirror;
Capture cap;
ImgProcessing pro;
OpenCV cv ;
Boolean mirrorReady = false;

//mirror must send and receive
Movie movie;
String fileName = "parameters.txt";
String clientIP1; // where to send
int clientPort = 8000; // where to send
DatagramSocket ds; 
DatagramSocket dsMessage; 
long time;
float fR;
//
//Ball stuff
Ball ball;
float sensibility ;

// Other images 
PImage other; //deprecated
ReceiverThread receiver;
MessageReceiverThread messageReceiver;


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
  String[] camera =  Capture.list();
 // printArray(camera);
  //cap = new Capture(this, camera[0]);
    
 cap = new Capture(this, 640,480);
  cap.start();
  //sender stuff
    String loadParameters[] = loadStrings(fileName);
  clientIP1 = loadParameters[0];
    try {
    ds = new DatagramSocket();
    dsMessage = new DatagramSocket();
  } 
  catch (SocketException e) {
    e.printStackTrace();
  }

  // start movie
  //movie = new Movie(this, "test.avi");
  //movie.loop();
  //
  
  
  messageReceiver = new MessageReceiverThread(messagePort);
  receiver = new ReceiverThread(port, 640, 480); // hc
  messageReceiver.start();
  receiver.start();
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
     //decide who has control
     // weight = lastmovement * sensibility
     // compare with other latest message  
    mirror.copy(cap, 0, 0, mirror.width, mirror.height, 0, 0, mirror.width, mirror.height); // deprecated
    
    realmirror.process(sensibility,ball);
    realmirror.detectFace();
    //broadcast(realmirror.processed);
    //pro.getEdges("canny", mirror)
    image(realmirror.processed,640,0);
    }
    if(realmirror.FaceDetected)
    {
        float distance = abs((float)(realmirror.face.getCenterX()+640) - ball.xpos) + abs((float)realmirror.face.getCenterY() - ball.ypos);
        sensibility = distance / 1280;
        //println("sensibility:" + sensibility);
        //println("face center" + realmirror.face.getCenterX() + "$$ sensibility:" + sensibility );
        ball.update(realmirror.face.getLocation(), realmirror.avgMotion);
        //broadcastMessage
        if(realmirror.avgMotion > 25)
        {
          println("Found Motion");
          Message m = new Message(0, realmirror.face.getLocation(), realmirror.avgMotion);
          broadcastMessage(m);
        }
        
    }
  ball.draw();
  
}

 
  void broadcastMessage(Message m)
  {
      byte[] packet = m.encodeMessage();
      try
      {
      ds.send(new DatagramPacket(packet, packet.length, InetAddress.getByName(clientIP1), messagePort));
      }catch (Exception e){
      e.printStackTrace();
      }
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
  
  