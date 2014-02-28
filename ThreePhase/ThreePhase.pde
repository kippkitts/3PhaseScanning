
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
|  Forked from https://code.google.com/p/structured-light/
|
|  Notes:
|  1. Updated for processing 2.X
|  2. Unfinished event handling code has been finished
|  3. Works with Image Capture for DLP Lightcrafter & MSP430
|                                                          
|    File name : ImageCaptureVer3.pde                       
|    Updated by:     K Bradford                             
|    Final edit date :   24 Feb, 2014                       
|                                                           
|                                                           
|    NOT FOR PRODUCTION                                     
\__________________________________________________________*/


/*
  Under "Import Library/Add Library"
    Import PeasyCam
    Import ControlP5
    
    Also need to import (included by me):
    import java.awt.Frame;        // KLB
    import java.awt.BorderLayout;  // KLB
    import java.util.PriorityQueue;
    
  Make sure openGL is up-to-date
 */

import peasy.*;

PeasyCam cam;

int inputWidth, inputHeight;
float[][] phase, distance, depth;
boolean[][] mask, process;
color[][] colors;
int[][] names;

boolean update, exportMesh, exportCloud;

void setup() {
  size(480, 640, P3D);
  
  loadImages();
  
  inputWidth = phase1Image.width;
  inputHeight = phase1Image.height;
  phase = new float[inputHeight][inputWidth];
  distance = new float[inputHeight][inputWidth];
  depth = new float[inputHeight][inputWidth];
  mask = new boolean[inputHeight][inputWidth];
  process = new boolean[inputHeight][inputWidth];
  colors = new color[inputHeight][inputWidth];
  names = new int[inputHeight][inputWidth];
  
  cam = new PeasyCam(this, width);  
       
  setupControls();

  update = true;


}

void draw () {
  background(0);
  translate(-width / 2, -height / 2);
  
  if(update) {
    phaseWrap();
    phaseUnwrap();
    update = false;
    println("Updated!");
  }
  
  makeDepth();
  
  noFill();
  for (int y = 0; y < inputHeight; y += renderDetail)
    for (int x = 0; x < inputWidth; x += renderDetail)
      if (!mask[y][x]) {
        stroke(colors[y][x], 255);
        point(x, y, depth[y][x]);
      }
  
  if(takeScreenshot) {
    saveFrame(getTimestamp() + ".png");
    takeScreenshot = false;
  }
  if(exportMesh) {
    doExportMesh();
    exportMesh = false;
  }
  if(exportCloud) {
    doExportCloud();
    exportCloud = false;
  }
}
