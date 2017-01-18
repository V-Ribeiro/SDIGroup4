public class Message
{
  String[] message;
  int type;
  Point face;
  float movement;
  
  public Message(int t, Point p, float m)
  {
    type = t;
    face = p;
    movement = m;
  }
  
  public Message(byte[] m)
  {
    String s = new String(m);
    println("got:" + s);
  }
  
  public void printMessage()
  {
    println("received: " + type );
  }
  
  public byte[] encodeMessage()
  {
    String m = "";
    switch(type)
    {
     case 0: {
       m += "0";
       m+="|";
       m += Double.toString(face.getX());
       m += "|";
       m += Double.toString(face.getY());
       m+="|";
       m += Float.toString(movement);
       break;
     }
    }
    byte[] ret = new byte[200];
    ret = m.getBytes();
    return ret;
  }
  
  

}