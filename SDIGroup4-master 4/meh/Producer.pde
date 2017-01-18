import processing.video.*;
import gab.opencv.*;
class FeedProducer
{
    int numPixels;
    Capture video;
    PImage prevFrameImage;
    OpenCV cv = null;  // OpenCV object
    float avgMotion = 1;


    
    

public FeedProducer(Capture c)
{
  this.video = c;
  prevFrameImage = createImage(640, 480, RGB);
  numPixels = 640 * 480;
  // Create an array to store the previously captured frame
  video.start();
}

public int frameDiff(){//TODO:detect left right above 
    int movementSum = 0; // Amount of movement in the frame
    for (int i = 0; i < numPixels; i++) { // For each pixel in the video frame...
      color currColor = video.pixels[i]; //
      color prevColor = prevFrameImage.pixels[i]; //
      // Extract the red, green, and blue components from current pixel
      int currR = (currColor >> 16) & 0xFF; // Like red(), but faster
      int currG = (currColor >> 8) & 0xFF;
      int currB = currColor & 0xFF;
      // Extract red, green, and blue components from previous pixel
      int prevR = (prevColor >> 16) & 0xFF;
      int prevG = (prevColor >> 8) & 0xFF;
      int prevB = prevColor & 0xFF;
      // Compute the difference of the red, green, and blue values
      int diffR = abs(currR - prevR);
      int diffG = abs(currG - prevG);
      int diffB = abs(currB - prevB);
      // Add these differences to the running tally
      movementSum += diffR + diffG + diffB;
    }
    return (int)(movementSum);
}
}