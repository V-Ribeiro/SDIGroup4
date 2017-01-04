import processing.video.*;
class FrameDiffConsumer
{
  // How different must a pixel be to be a "motion" pixel
float threshold = 50;
float positionX;
float positionY;
float radiusProportion = 0.1;
float speed; 
float gravity;

int totalMovement=0;

public FrameDiffConsumer()
{
  positionX = width / 2;
  positionY = height / 2;
  speed = 0;
  gravity = 0.07;
}
}

class DisplayConsumer
{
FeedProducer feed;
FeedProducer another;
float effect;
PImage out;
PImage one;
PImage two;


   public DisplayConsumer(FeedProducer m,FeedProducer n)
   {
     feed = m;
     another = n;
     out = createImage(640, 480, RGB);
     one = createImage(640, 480, RGB);
     two = createImage(640, 480, RGB);
   }

   public void mix(Ball b)
   {
     println("posX:" + b.posX + " posY:"+ b.posY +" velX:"+ b.velX+ " velY:" + b.velY + " radius:" + b.radius);
     float curr = millis();
     println("TIME" + curr);
     float mov1,mov2;
     mov1 = feed.avgMotion;
     mov2 = another.avgMotion;
     if(mov1 > 50 || mov2 > 50)
     {
          if(mov1 > mov2)
         {
         b.setVelocity(1,0);
         }
         else
         {
         b.setVelocity(-1,0);
         }
     }
     out.copy(another.video, 0, 0, one.width, one.height, 0, 0, one.width, one.height);
     out.blend(feed.video,0, 0, 640, 480,  0, 0,640,480, DARKEST );
     b.calc();
   }
   

   PImage getImage()
   {
   return out;
   }
}