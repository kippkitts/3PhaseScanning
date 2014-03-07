
/*__________________________________________________________\
|                                                           
|  Feburary 2014                                            
|  Copyright kippkitts, LLC 2014                            
|  All Rights Reserved                                      
|                                                           
|  kippkitts, LLC                                           
|  999 Main Street, Suite 705                               
|  Pawtucket, RI USA                                        
|  Tel: 401-400-0548, Fax: 401-475-3574                     
|                                                           
|      3Phase Image Capture Code                            
|                        
| Redistribution and use in source and binary forms,
| with or without modification, are permitted provided
| that the following conditions are met:
| 1. Redistributions of source code must retain the above
| copyright notice, this list of conditions and
| the following disclaimer.
| 2. Redistributions in binary form must reproduce the
| above copyright notice, this list of conditions and the
| following disclaimer in the documentation and/or
| other materials provided with the distribution.
| 3. Neither the name of the copyright holder nor
| the names of its contributors may be used to endorse
| or promote products derived from this software without
| specific prior written permission.
| 
| THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND 
| CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
| INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
| MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
| ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
| OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
| INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
| DAMAGES (INCLUDING, BUT NOT LIMITED TO,
| PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE
| DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED
| AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
| STRICT LIABILITY, OR TORT
| (INCLUDING NEGLIGENCE OR OTHERWISE)
| ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
| EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
|
|                                                           
| kippkitts HAS MADE EVERY EFFORT TO INSURE THAT            
| THE CODE CONTAINED IN THIS RELEASE IS ERROR-FREE.         
| HOWEVER, kippkitts DOES NOT WARRANT THE                   
| OPERATION OF THE CODE, ASSOCIATED FILES,                  
| SCHEMATICS &/OR OTHER ENGINEERING MATERIAL.               
|                                                           
| THESE MATERIALS WERE PRODUCED FOR EVALUATION              
| PURPOSES ONLY, AND ARE NOT INTENDED FOR                   
| PRODUCTION.                                               
|                                                           
| kippkitts ACCEPTS NO RESPONSIBILITY OR LIABILITY          
| FOR THE USE OF THIS MATERIAL, OR ANY PRODUCTS             
| THAT MAY BE BUILT WHICH UTILIZE IT.                       
|                                                           
|                                                          
|    File name : ImageCaptureVer3.pde                       
|    Written by:     V Saliu, K Bradford                             
|    Final edit date :   24 Feb, 2014                       
|                                                           
|                                                           
|    NOT FOR PRODUCTION                                     
\__________________________________________________________*/

// This program is designed to run an MSP430 Launchpad running software that triggers
// the indexing of pre-programmed image files on a DLPLightcrafter projector

import processing.video.*;    // Get the video capture driver libraries
import processing.serial.*;   // Get the serial I/O driver libraries

Serial myPort;                       // The serial port
int phaseNum = 0;
boolean saveImg = false;

Capture cam;


void setup() {
  //size(1280, 800);  // Size of capture window needs to match resolution of the camera
  size(640, 480);  // Size of capture window needs to match resolution of the camera

  String[] cameras = Capture.list();
 
 
  // You need to run the program once to generate a list of available serial ports.
  // Then change the "index" of Serial.list()[index] to match the port your Launchpad is attached to 
  println(Serial.list());
  myPort = new Serial(this, Serial.list()[1], 9600);

  if (cameras == null) {
    println("Failed to retrieve the list of available cameras, will try the default...");
//    cam = new Capture(this, 1280, 800);  // Capture buffer also needs to match the resolution of the camera
      cam = new Capture(this, 640, 480);  // Capture buffer also needs to match the resolution of the camera
  } 
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }

    // The camera can be initialized directly using an element
    // from the array returned by list():
    cam = new Capture(this, cameras[0]); 
    // Or, the settings can be defined based on the text in the list
    //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

    // Start capturing the images from the camera
    cam.start();
  }

  // Set phase one here

}

void draw() {

  if (cam.available() == true) {
    cam.read();
    set(0, 0, cam);//NO NEED TO CALL SET MORE THAN ONCE FOR THE SAME CAM IMAGE
  } 

  delay(1000);  // Add some delay to help slower computers
  if (phaseNum>0) {
    saveFrame("phase"+phaseNum+".jpg");
    println("Saved Phase" + phaseNum);
    delay(1000);  // Add some delay to help DLP
    delay(1000);  // Add some delay to help DLP
    MSP430_SetPhase(phaseNum + 1);  // Switch to the next phase
    delay(1000);  // Add some delay to help DLP
    delay(1000);  // Add some delay to help DLP
    println("Switched to phase" + phaseNum);
  }
  phaseNum++;
  if (phaseNum == 4)
  {
    exit();
  }
}

int MSP430_SetPhase(int thisPhase)
{
  // Right now, the MSP430 code just toggles the trigger pin to switch projected phases
  // 
  myPort.write("next:0");
  return thisPhase;  // Just echo back the phase for now
}
