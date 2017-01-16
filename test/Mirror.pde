import processing.video.*;
public class Mirror
{
  ImgProcessing tool;
  PImage background,subtractedBackground,capture, other, processed,display;
  Boolean CapturedBackground = false;
  Boolean CaptureReady = false;
  Boolean FaceDetected = false;
  int w = 640;
  int h = 480;
public Mirror(ImgProcessing t){
	tool = t;
    background = createImage(w, h, RGB);
    subtractedBackground = createImage(w, h, RGB);
    capture = createImage(w, h, RGB);
    other = createImage(w,h,RGB);
    processed = createImage(w, h, RGB);
    display = createImage(w*2, h, RGB);
}



    public void updateCapture(PImage cap)
    {
    capture.copy(cap,0, 0, w, h, 0, 0, w, h);
    }
    
    public void process()
    {
    processed.copy(tool.PreProcessImg(capture),0, 0, w, h, 0, 0, w, h);
    }
    
    public void updateDisplay()
    {
    display.copy(capture,0, 0, w, h, 0, 0, w, h);
    display.copy(other,640, 0, w, h, 0, 0, w, h);
    }
    
    public void updateOther(PImage o)
    {
     other.copy(o,0, 0, other.width, other.height, 0, 0, other.width, other.height);
    }
    
    public void detectFace()
    {
    
    }
    
     
    public void subtractBackground()
    {
    //subtractedBackground
    }
    
    public void setBackground(PImage bgd){
    	background.copy(bgd,0, 0, w, h, 0, 0, w, h);
    }
}