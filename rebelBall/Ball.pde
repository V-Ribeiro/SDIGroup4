
public class Ball
{
  int posX;
  int posY;
  int velX;
  int velY;
  int radius;
  
  public Ball(int x , int y)
  {//initial position
    posX = x;
    posY = y;
    velX = 0;
    velY = 0;
    radius = 50;
  }
  
    public Ball(int x, int y, int vX, int vY, int r)
  {
      posX = x;
      posY = y;
      velX = vX;
      velY = vY;
      radius = r;
  }
  
  void calc()
  {
      if (posX < 0 || posX > width) velX *= -1;
      if (posY < 0 || posY > height) velY *= -1;
      posX += velX;
      posY += velY;
  }
  
  void setRadius(int r)
  {
    radius = r;
  }
  
  void setVelocity(int vX, int vY)
  {
    
    velX = vX;
    velY = vY;
  }
  
  void draw()
  {
    ellipse(posX, posY, radius, radius);
  }
}