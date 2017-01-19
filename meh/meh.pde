import processing.video.*;
import processing.sound.*;

// Variable for capture device
Capture video;
// Previous Frame
PImage prevFrame;
PImage photo;
PGraphics graphicalMask;
SoundFile song;

// motion variables
float threshold = 50;
float positionX;
float positionY;
float radiusProportion = 0.1;
float speed; 
float gravity;
float volume = 0;
boolean lazy5 = false;
boolean lazy10 = false;

//time variables
int savedTime;
int savedTime2;
int totalTime = 10000;

//bubble variables
int numBalls = 12;
float spring = 0.05;
float friction = -0.9;
Ball[] balls = new Ball[numBalls];

int iw, ih;

void setup() {
    photo = loadImage("img1.png");
    song = new SoundFile(this, "22.mp3");
    song.loop();
    song.amp(0);
    
    iw = photo.width;
    ih = photo.height;
    graphicalMask = createGraphics(iw, ih);
    for (int i = 0; i < numBalls; i++) {
    balls[i] = new Ball(random(width), random(height), random(30, 70), i, balls);
  }
    
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
  savedTime = millis();
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

    if (totalMotion > 5000000.0 && lazy10 == false) {
      meterEfeito(); 
      volume = totalMotion / 1000000.0;
      song.amp(volume);
      lazy5 = false;
    } else { 
      if (lazy5 == false && lazy10 == false) {
        song.amp(0);
      }
      // Calculate how much time has passed
      int passedTime = millis() - savedTime;
      // Has five seconds passed?
      if (passedTime > totalTime) {
        println("5 seconds have passed!");
        lazy5 = true;  
          savedTime2 = millis();
      }
    }

//weak effect with volume
if (lazy5 == true) {
  meterEfeito2();
  volume = (totalMotion / 1000000.0) / 10;
  song.amp(volume);
  // Calculate how much time has passed
  int passedTime2 = millis() - savedTime2;
  // Has five seconds passed?
      if (passedTime2 > totalTime) {
        lazy5 = false;
        lazy10 = true;   
      }
}

if (lazy10 == true) {
  meterEfeito3();
  volume = (totalMotion / 1000000.0) / 2;
  song.amp(volume);
          ballSpawn();
}

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
}

void meterEfeito() { 
savedTime = millis();
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
        // change motion to red
        pixels[loc] = color(221, 23, 27);
        
      } else {
        // everything else is null (new version)
        //pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
}

void meterEfeito2() { 
savedTime = millis();
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
        // change motion to dirty green
        pixels[loc] = color(0, 23, 27);
      } else {
        // everything else is null (new version)
        //pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
}

void meterEfeito3() { 
savedTime = millis();
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
        // change motion to green
        pixels[loc] = color(0, 255, 27);
      } else {
        // everything else is null (new version)
        //pixels[loc] = color(255);
      }
    }
  }
  updatePixels();
}

void ballSpawn() {
  for (Ball ball : balls) {
    ball.collide();
    ball.move();
    ball.display();  
  }
}

class Ball {
  
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  Ball[] others;
 
  Ball(float xin, float yin, float din, int idin, Ball[] oin) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
  } 
  
  void collide() {
    for (int i = id + 1; i < numBalls; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }   
  }
  
  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction; 
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction; 
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }
  
  void display() {
    ellipse(x, y, diameter, diameter);
  }
}
