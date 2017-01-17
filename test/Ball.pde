public class Ball
{
/**
 * Bounce. 
 * 
 * When the shape hits the edge of the window, it reverses its direction. 
 */
 
int rad = 60;        // Width of the shape
float xpos = 640;
float ypos= 240;    // Starting position of shape    

float xspeed = 2.8;  // Speed of the shape
float yspeed = 2.2;  // Speed of the shape

int xdirection = 0;  // Left or Right
int ydirection = 0;  // Top to Bottom

void Ball() 
{
  color c = color(204,102,0);  // Define color 'c'
  frameRate(30);
  ellipseMode(RADIUS);

  // Set the starting position of the shape
  xpos = 640/2;
  ypos = 480/2;
}

//scale
//the bigger the faceRectangles the bigger the ball


  public void update(Point p , float movement)
  {
    /// if ball is far, the more reactive the ball is to movemnt
    ///
    //point p is last known position of face
    println("facex:"+ p.getX() + "  facey:" + p.getY());
    println("ballx:"+ xpos + "  bally:" + ypos);
   float xDiff = xpos - (float)p.getX();
    float yDiff = ypos - (float)p.getY();
   
    println("xDiff: " + xDiff + "  yDiff: " +yDiff  );
    if(xDiff > 0)
    {
      xdirection = 1;
    }
  }

  void draw(){
    // Update the position of the shape
    xpos = xpos + ( xspeed * xdirection );
    ypos = ypos + ( yspeed * ydirection );
    // Test to see if the shape exceeds the boundaries of the screen
    // If it does, reverse its direction by multiplying by -1
    if (xpos > width-rad || xpos < rad) {
      xdirection *= -1;
    }
    if (ypos > height-rad || ypos < rad) {
      ydirection *= -1;
    }
  
    // Draw the shape
    fill(204,102,0);  // Use color variable 'c' as fill color
    ellipse(xpos, ypos, rad, rad);
  }
  
}