import processing.video.*;
import gab.opencv.*;
class FeedProducer
{
    int numPixels;
    Capture video;
    OpenCV cv = null;  // OpenCV object
    PImage background;
    PImage sub_background;
    PImage dilated;

  public FeedProducer(Capture c, OpenCV v)
  {
    this.video = c;
    this.cv = v;
    video.start();
    background = createImage(640, 480, RGB);
    sub_background = createImage(640, 480, RGB);
    dilated = createImage(640, 480, RGB);
  }
  
  public void updateFlow()
  {
       cv.loadImage(video);
       cv.calculateOpticalFlow();
       PVector aveFlow = cv.getAverageFlow();
       println("avgFlow:::"+aveFlow.x+"!"+aveFlow.y);
  }
  
  public void setBackground()
  {
     background.copy(video, 0, 0, background.width, background.height, 0, 0, background.width, background.height);
  }
  
    public PImage removeBackground()
  {
      PImage recent = new PImage(video.getImage()); 
      
      cv.loadImage(background);    
      cv.diff(recent);
      sub_background.copy(cv.getSnapshot(), 0, 0, sub_background.width, sub_background.height, 0, 0, sub_background.width, sub_background.height);
      return sub_background;
  }
  
  public PImage dilate()
  {
   cv.loadImage(display.getImage());
   cv.gray();
   cv.dilate();
   cv.threshold(15);
   cv.erode();
     //cv.adaptiveThreshold(400, 2);
   //cv.inRange(20,40);

   dilated.copy(cv.getSnapshot(), 0, 0, dilated.width, dilated.height, 0, 0, dilated.width, dilated.height);
   return dilated;

  }

 
  
}