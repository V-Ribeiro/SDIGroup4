import processing.video.*;


class DisplayConsumer
{
FeedProducer feed;
PImage background;
PImage out;



   public DisplayConsumer(FeedProducer m)
   {
     feed = m;
     out = createImage(640, 480, RGB);
   }

   public void mix(Ball b)
   {
     if(!configCapture)
     {
       out.copy(feed.video, 0, 0, out.width, out.height, 0, 0, out.width, out.height);
     } 
     else
     {
       out.copy( feed.sub_background, 0, 0, out.width, out.height, 0, 0, out.width, out.height);
     }
   }
   

   public PImage getImage()
   {
   return out;
   }
   
   public void setImage(PImage img)
   {
     out.copy(img, 0, 0, out.width, out.height, 0, 0, out.width, out.height);
   }
}