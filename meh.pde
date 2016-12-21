// Example 16-14: Overall motion

import processing.video.*;

// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;

// How different must a pixel be to be a "motion" pixel
float threshold = 50;
float positionX;
float positionY;
float radiusProportion = 0.1;
float speed; 
float gravity;


void setup() {
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
    positionY = positionY + speed;
    speed = speed + gravity;
      
      // isto serve para alterar o positionY
      if ( speed < 0.65 && positionY > height - width * radiusProportion) {
        println("bottom");
        speed = 0;
        gravity = 0;
      }
      else if (positionY > height - width * radiusProportion) {
        println(speed);
        speed = speed * -0.65;
        println("Change Direction");
      } 
  
}