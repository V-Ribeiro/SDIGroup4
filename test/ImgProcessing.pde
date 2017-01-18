import gab.opencv.*;
import java.awt.Rectangle;
import java.awt.Point;

public class ImgProcessing
{
    OpenCV cv;
    Rectangle[] faces;
    PImage current,previous;
    Rectangle faceSquare;
    
  public ImgProcessing(OpenCV c){
    cv = c;
  }
  
  public Rectangle detect(PImage img)
  {
    cv.loadImage(img);
    faces = cv.detect();
    if(faces.length != 0)
    {
      for(int i =0 ; i < faces.length ; i++)
      {
        if(faces[i].getWidth() > 100 && faces[i].getHeight() > 100 )
        {
          //println(faces[i].getLocation() + "||" + faces[i].getSize() );
          faceSquare = faces[i];
          return faceSquare;
        }
      }
    } 
    return null;
  }
  
  public PImage erode (PImage p){
    cv.loadImage(p);
    cv.erode();
    return cv.getOutput();
  }
  
    public PImage dilate (PImage p){
    cv.loadImage(p);
    cv.dilate();
    return cv.getOutput();
  }
  
    public PImage PreProcessImg (PImage p,float s){
    cv.loadImage(p);
    //cv.gray();
    cv.threshold(20 + 10 * (int)(1/s) );
    
    return cv.getOutput();
  }
  
  
  public PImage meterEfeito(PImage recentImage , PImage previousImage) { 
  int savedTime = millis();
  float threshold = 270;
  for (int x = 0; x < recentImage.width; x ++ ) {
    for (int y = 0; y < recentImage.height; y ++ ) {

      int loc = x + y*recentImage.width;            // Step 1, what is the 1D pixel location
      color current = recentImage.pixels[loc];      // Step 2, what is the current color
      color previous = previousImage.pixels[loc]; // Step 3, what is the previous color

      // Step 4, compare colors (previous vs. current)
      float r1 = red(current); 
      float g1 = green(current); 
      float b1 = blue(current);
      float r2 = red(previous); 
      float g2 = green(previous); 
      float b2 = blue(previous);
      float diff = dist(r1, g1, b1, r2, g2, b2);

      // Step 5, How different are the colors?
      // If the color at that pixel has changed, then there is motion at that pixel.
      if (diff > threshold) { 
        // change motion to white
        recentImage.pixels[loc] = color(255);
      } else {
        // everything else is colored
        recentImage.pixels[loc] = color(221, 23, 27);
      }
    }
  }
  return recentImage;
}

  
  public PImage getEdges(String type, PImage src){
    switch(type)
    {
      case "canny":
      {
        cv.loadImage(src);
        cv.findCannyEdges(10,50);
        break;
      }
    }
    return cv.getOutput();
  }
  
  public float getMotion( PImage previous, PImage current){
  float totalMotion = 0;
  // Sum the brightness of each pixel
  for (int i = 0; i < current.pixels.length; i ++ ) {
    // Step 2, what is the current color
    color currentColor = current.pixels[i];
    // Step 3, what is the previous color
    color previousColor = previous.pixels[i];
    // Step 4, compare colors (previous vs. current)
    float r1 = red(currentColor); 
    float g1 = green(currentColor);
    float b1 = blue(currentColor);
    float r2 = red(previousColor); 
    float g2 = green(previousColor);
    float b2 = blue(previousColor);
    // Motion for an individual pixel is the difference between the previous color and current color.
    float diff = dist(r1, g1, b1, r2, g2, b2);
    // totalMotion is the sum of all color differences. 
    totalMotion += diff;
  }
    // averageMotion is total motion divided by the number of pixels analyzed.
  float avgMotion = totalMotion / current.pixels.length; 
  //println("total motion" + totalMotion + "  avgMotion:" + avgMotion);
  return avgMotion;
  }
  
  
  
  
  
}