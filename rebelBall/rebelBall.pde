import gab.opencv.*;
import processing.video.*;

DisplayConsumer display;
FeedProducer camerafeed;
String cameraName= "name=ASUS USB2.0 WebCam,size=640x480,fps=30";
Ball ball;
OpenCV cv;

Boolean configCapture = false;


void setup() {
  size(640, 480);
  
  String[] cameras = Capture.list();
    if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
   // FeedConsumer = ()
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);
    // The camera can be initialized directly using an element
    // from the array returned by list():
    //name ? 
    cv = new OpenCV(this, 640, 480);
    camerafeed= new FeedProducer(new Capture(this, cameraName), cv);
    ball = new Ball((int)(640/2),(int)(480/2));
    ball.setRadius(30);
    
  }

}


// New frame available from camera
  void captureEvent(Capture video) {
    /*
    if(configCapture)
    {
      */
      camerafeed.video.read();
      camerafeed.setBackground();
      //camerafeed.updateFlow();
      /*
    } else
    {
      */
    configCapture = true;
   // }

  }


void draw() {
  if(configCapture)
  {
  display.setImage(camerafeed.removeBackground());
  }
  
 display = new DisplayConsumer(camerafeed);
 display.mix(ball);
 display.setImage(camerafeed.dilate());
 image(display.getImage(), 0, 0, width, height);
     //ball.draw();

}