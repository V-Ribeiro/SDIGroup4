import gab.opencv.*;
import java.awt.Rectangle;

public class ImgProcessing
{
    OpenCV cv;
    Rectangle[] faces;
  public ImgProcessing(OpenCV c){
    cv = c;
  }
  
  public void detect(PImage img)
  {
    cv.loadImage(img);
    cv.loadCascade(OpenCV.CASCADE_FRONTALFACE);  
    faces = cv.detect();
  }
}