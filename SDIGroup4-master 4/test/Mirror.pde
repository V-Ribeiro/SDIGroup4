import processing.video.*;
public class Mirror
{
  ImgProcessing tool;
  PImage background,subtractedBackground,capture, other, processed,display, previous;
  Boolean CapturedBackground = false;
  Boolean CaptureReady = false;
  Boolean FaceDetected = false;
  Rectangle face;
  int w = 640;
  int h = 480;
  float avgMotion =0;
  
  
public Mirror(ImgProcessing t){
    tool = t;
    background = createImage(w, h, RGB); // not used
    subtractedBackground = createImage(w, h, RGB); // not used
    previous = createImage(w, h, RGB);
    capture = createImage(w, h, RGB);
    other = createImage(w,h,RGB);
    processed = createImage(w, h, RGB);
    display = createImage(w*2, h, RGB);
}

    //update previous and current frame for movement calc
    public void updateCapture(PImage cap)
    {
      previous.copy(capture,0, 0, w, h, 0, 0, w, h);  
      capture.copy(cap,0, 0, w, h, 0, 0, w, h);
    }
    
    
    public void process(float s,Ball b)
    {
      /*
      if(isOnMirrorSide(b))
      {
          processed.copy(tool.dilate(capture),0, 0, w, h, 0, 0, w, h);
      }
      else
      {
          processed.copy(tool.erode(capture),0, 0, w, h, 0, 0, w, h);
      }
      */
          //processed.copy(tool.PreProcessImg(capture,s),0, 0, w, h, 0, 0, w, h);
          processed.copy(tool.getEdges("canny",capture),0, 0, w, h, 0, 0, w, h);
    }
    
    //concatenate images
    public void updateDisplay(){
      display.copy(capture,0, 0, w, h, 0, 0, w, h);
      display.copy(other,640, 0, w, h, 0, 0, w, h);
    }
    
    public Boolean isOnMirrorSide(Ball b)
    {
    if(b.xpos > 640)
    return true;
    else
    return false;
    }
    
    public void updateOther(PImage o)
    {
     other.copy(o,0, 0, other.width, other.height, 0, 0, other.width, other.height);
    }
    
    public void detectFace()
    {
      Rectangle t = tool.detect(capture);
      if(t != null)
      {
        face = t;
        FaceDetected = true;
      }
    }
    
    public void getMovement()
    {
    avgMotion = tool.getMotion(previous,capture);
    }
    
    /// not used
    public void subtractBackground()
    {
    //subtractedBackground
    }
    
    public void setBackground(PImage bgd){
      background.copy(bgd,0, 0, w, h, 0, 0, w, h);
    }
}