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

int xdirection = 1;  // Left or Right
int ydirection = 1;  // Top to Bottom


void Ball() 
{
  color c = color(204,102,0);  // Define color 'c'
  frameRate(30);
  ellipseMode(RADIUS);

  // Set the starting position of the shape
  xpos = 640/2;
  ypos = 480/2;
}

void draw() 
{
  
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