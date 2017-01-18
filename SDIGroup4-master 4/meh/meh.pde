import gab.opencv.*;
import processing.video.*;


DisplayConsumer display;
FeedProducer camerafeed;
FeedProducer anothercamerafeed;
FrameDiffConsumer frameDiff;
String cameraName= "name=ASUS USB2.0 WebCam,size=640x480,fps=30";
String cameraName2 = "name=Logitech QuickCam Express/Go,size=640x480,fps=30";
Ball ball;
int recentMovement = 0;
int totalMotion = 0;
OpenCV cv;


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
    camerafeed= new FeedProducer(new Capture(this, cameraName));
    anothercamerafeed = new FeedProducer(new Capture(this,cameraName2));
    ball = new Ball((int)(640/2),(int)(480/2));
    ball.setRadius(30);
    
  }

}


// New frame available from camera
void captureEvent(Capture video) {
  println("...");
  if(camerafeed.video.equals(video))
  {
    print("0");
    camerafeed.prevFrameImage.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
    //camerafeed.prevFrameImage.updatePixels();
    camerafeed.video.read();
    //camerafeed.currFrameImage.copy(video,0,0,video.width, video.height,0,0,video.width,video.height);
    int diff = camerafeed.frameDiff();
    camerafeed.avgMotion = diff / camerafeed.video.pixels.length;
    totalMotion += diff;
    println("average motion : 0 ||"+ camerafeed.avgMotion);
  }else
  {
     print("1");
    anothercamerafeed.prevFrameImage.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
    //anothercamerafeed.prevFrameImage.updatePixels();
    anothercamerafeed.video.read();
    int diff = anothercamerafeed.frameDiff();
    anothercamerafeed.avgMotion = diff / anothercamerafeed.video.pixels.length;
    totalMotion += diff;
    println("average motion : 1 ||"+ anothercamerafeed.avgMotion); 
    //camerafeed.currFrameImage.copy(video,0,0,video.width, video.height,0,0,video.width,video.height);
  }
}


void draw() {
 display = new DisplayConsumer(camerafeed,anothercamerafeed);
 display.mix(ball);
       cv.loadImage(display.getImage());
       cv.calculateOpticalFlow();
         image(video, 0, 0);
  translate(video.width,0);
  stroke(255,0,0);
  cv.drawOpticalFlow();
  
  PVector aveFlow = c.getAverageFlow();
  int flowScale = 50;
  
  stroke(255);
  strokeWeight(2);
  line(240, 320, 240 + aveFlow.x*flowScale,320 + aveFlow.y*flowScale);

 image(display.getImage(), 0, 0, width, height);
     ball.draw();

}