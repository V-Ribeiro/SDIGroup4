import processing.video.*;
import processing.sound.*;

// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
PImage photo;
PGraphics graphicalMask;
SoundFile song;

// How different must a pixel be to be a "motion" pixel
float threshold = 50;
float positionX;
float positionY;
float radiusProportion = 0.1;
float speed; 
float gravity;
float volume = 0;

int iw, ih;

void setup() {
    photo = loadImage("img1.png");
    song = new SoundFile(this, "22.mp3");
    song.loop();
    song.amp(0);
    
    iw = photo.width;
    ih = photo.height;
    graphicalMask = createGraphics(iw, ih);
    
  size(640, 480);
  // Using the default capture device
  video = new Capture(this, width, height);
  video.start();
  // Create an empty image the same size as the video
  prevFrame = createImage(video.width, video.height, RGB);
  positionX = width / 2;
  positionY = height / 2;
  speed = 0;
  gravity = 0.07;
}

// New frame available from camera
void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame.updatePixels();
  video.read();
}

void draw() {
  background(0);

  // You don't need to display it to analyze it!
  image(video, 0, 0);
  
  loadPixels();
  video.loadPixels();
  prevFrame.loadPixels();

  // Begin loop to walk through every pixel
  // Start with a total of 0
  float totalMotion = 0;

  // Sum the brightness of each pixel
  for (int i = 0; i < video.pixels.length; i ++ ) {
    // Step 2, what is the current color
    color current = video.pixels[i];

    // Step 3, what is the previous color
    color previous = prevFrame.pixels[i];

    // Step 4, compare colors (previous vs. current)
    float r1 = red(current); 
    float g1 = green(current);
    float b1 = blue(current);
    float r2 = red(previous); 
    float g2 = green(previous);
    float b2 = blue(previous);

    // Motion for an individual pixel is the difference between the previous color and current color.
    float diff = dist(r1, g1, b1, r2, g2, b2);
    // totalMotion is the sum of all color differences. 
    totalMotion += diff;
}

  // averageMotion is total motion divided by the number of pixels analyzed.
  float avgMotion = totalMotion / video.pixels.length; 

  // Draw a circle based on average motion
  noStroke();
  fill(0);
  float r = avgMotion * 2;   
      
   ellipse(positionX, positionY, r, r);  
   //graphicalMask.beginDraw();
   //graphicalMask.background(photo);
   //graphicalMask.ellipse(positionX, positionY, r, r);  
   //graphicalMask.endDraw();
   //image(graphicalMask, 1, 1);
    
    positionY = positionY + speed;
    speed = speed + gravity;
      
      // isto serve para alterar o positionY
      if ( speed < 0.65 && positionY > height - width * radiusProportion) {
        println("bottom");
        println(totalMotion);
        speed = 0;
        gravity = 0;
      }
      else if (positionY > height - width * radiusProportion) {
        println(speed);
        speed = speed * -0.65;
        println("Change Direction");
        println(totalMotion);
      }
    if (totalMotion > 5000000.0) {
      meterEfeito(); 
      volume = totalMotion / 1000000.0;
      song.amp(volume);
    } else { 
      song.amp(0);   

    }
}

void meterEfeito() { 
for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {

      int loc = x + y*video.width;            // Step 1, what is the 1D pixel location
      color current = video.pixels[loc];      // Step 2, what is the current color
      color previous = prevFrame.pixels[loc]; // Step 3, what is the previous color

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
        pixels[loc] = color(255);
      } else {
        // everything else is colored
        pixels[loc] = color(221, 23, 27);
      }
    }
  }
  updatePixels();
}
