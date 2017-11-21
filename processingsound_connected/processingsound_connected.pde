/**
 * Processing Sound Library, Example 1
 * https://processing.org/tutorials/sound/
 * Five sine waves are layered to construct a cluster of frequencies. 
 * This method is called additive synthesis. Use the mouse position 
 * inside the display window to detune the cluster.
 */

import processing.sound.*;
import processing.serial.*;

Serial myPort;  // Create object from Serial class


SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

void setup() {  
  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  portName = "/dev/ttyUSB0";
  myPort = new Serial(this, portName, 9600);


  size(640, 360);
  background(255);

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

void draw() {

  String sval="";     // Data received from the serial port

  if ( myPort.available() > 0) 
  {  // If data is available,
    sval = myPort.readStringUntil('\n');         // read it and store it in val
  } 
  println("sval="+sval); //print it out in the console

    int ival = getNum(sval);    
    println("ival="+ival);
    
    if (ival >100) {



      //Map mouseY from 0 to 1
      float yoffset = map(mouseY, 0, height, 0, 1);
      if ( ival < 512)
          yoffset = map(ival, 0, 512, 0, 0.75);
      else
          yoffset = map(ival, 512, 1024, 0.75, 1);
      
      //Map mouseY logarithmically to 150 - 1150 to create a base frequency range
      float frequency = pow(1000, yoffset) + 150;
      //Use mouseX mapped from -0.5 to 0.5 as a detune argument
      float detune = map(mouseX, 0, width, -0.5, 0.5);

      for (int i = 0; i < numSines; i++) { 
        sineFreq[i] = frequency * (i + 1 * detune);
        // Set the frequencies for all oscillators
        sineWaves[i].freq(sineFreq[i]);
      }
    }
}


int getNum(String s){
  if(s==null) return -1;
  
  String out="";
  for(int i=0;i<s.length();i++){
    char c=s.charAt(i);
    if(isNum(c))
      out+=c;
  }
  
  if (out.length()==0) return -1;
  return Integer.parseInt(out);
  
}



boolean isNum(char c){
  
  if(c>='0' && c <= '9')
    return true;
    else
      return false;
}