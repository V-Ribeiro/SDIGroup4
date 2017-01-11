import processing.sound.*;

SoundFile song;
float volume = 1;
float pan = -1.0;

void setup() {
song = new SoundFile(this, "22_2.mp3");
    song.loop();
    song.amp(volume);

    
}

void draw() {
  background(0);
  song.pan(pan);
}

//whenever you click on the canvas the sound changes between left and right outputs
void mouseClicked() {
  if (pan == -1.0) {
    pan = 1.0;
  } else {
    pan = -1.0;
  }
}