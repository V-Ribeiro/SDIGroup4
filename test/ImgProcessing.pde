import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;

public class ImgProcessing
{
    OpenCV cv;
    Rectangle[] faces;
    Boolean faceDetected = false;
    
    Rectangle faceSquare;
    
  public ImgProcessing(OpenCV c){
    cv = c;
  }
  
  public void detect(PImage img)
  {
    cv.loadImage(img);
    faces = cv.detect();
    println("nfaces: " + faces.length);
    if(faces.length != 0)
    {
        println(faces[0].getLocation() + "||" + faces[0].getSize() );
        faceSquare = faces[0];
        faceDetected=true;
    } 
  }
  
  public PImage erode (PImage p)
  {
    cv.loadImage(p);
    cv.erode();
    return cv.getOutput();
  }
  
    public PImage dilate (PImage p)
  {
    cv.loadImage(p);
    cv.dilate();
    return cv.getOutput();
  }
  
      public PImage PreProcessImg (PImage p)
  {
    cv.loadImage(p);
    cv.gray();
    cv.threshold(30);
    return cv.getOutput();
  }
  
  
  
}