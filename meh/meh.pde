import processing.video.*;

// Variable for capture devices
Capture video1;
Capture video2;
// Previous Frame
PImage prevFrame_video1;
PImage prevFrame_video2;

// How different must a pixel be to be a "motion" pixel
float threshold = 50;
float positionX;
float positionY;
float radiusProportion = 0.1;
float speed; 
float gravity;


void setup() {
  size(1280, 480);
  String[] cameras = Capture.list();
    if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
    video1 = new Capture(this, 640, 480);
  } if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    printArray(cameras);
    // The camera can be initialized directly using an element
    // from the array returned by list():
    video1 = new Capture(this, 640, 480);
    //video2 = new Capture(this, 640, 480);
    video2 = new Capture(this, cameras[14]);
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);
    
    // Start capturing the images from the cameras
    video1.start();
    video2.start();
  }
  // Create an empty image the same size as the video
  prevFrame_video1 = createImage(video1.width, video1.height, RGB);
  prevFrame_video2 = createImage(video2.width, video2.height, RGB);
  positionX = width / 2;
  positionY = height / 2;
  speed = 0;
  gravity = 0.07;
}
/*
// New frame available from camera
void captureEvent(Capture video) {
  // Save previous frame for motion detection!!
  prevFrame_video1.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  prevFrame_video1.updatePixels();
  video.read();
}
*/
void draw() {
  background(0);

  // You don't need to display it to analyze it!
  image(video1, 0, 0);
  image(video2, 640, 0);

  video1.loadPixels();
  video2.loadPixels();
  
  prevFrame_video1.loadPixels();
  prevFrame_video2.loadPixels();

  // Begin loop to walk through every pixel
  // Start with a total of 0
  float totalMotion = 0;

  // Sum the brightness of each pixel
  for (int i = 0; i < video1.pixels.length; i ++ ) {
    // Step 2, what is the current color
    color current = video1.pixels[i];

    // Step 3, what is the previous color
    color previous = prevFrame_video1.pixels[i];

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
  float avgMotion = totalMotion / video1.pixels.length; 

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