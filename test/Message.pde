public class Message
{
  String[] message;
  int type;
  Point face;
  float movement;
  
  public Message(int t, Point p)
  {
    type = t;
    face = p;
  }
  
  public byte[] encodeMessage()
  {
    return new byte[10];
  }
  
    public String[] decodeMessage()
  {
    return new String[10];
  }
  

}