/*
 These three variables are the main "settings".
 
 zscale corresponds to how much "depth" the image has,
 zskew is how "skewed" the imaging plane is.
 
 These two variables are dependent on both the angle
 between the projector and camera, and the number of stripes.
 The sign on both is based on the direction of the stripes
 (whether they're moving up vs down)
 as well as the orientation of the camera and projector
 (which one is above the other).
 
 noiseThreshold can significantly change whether an image
 can be reconstructed or not. Start with it small, and work
 up until you start losing important parts of the image.
 */
 
import java.awt.Frame;        // KB
import java.awt.BorderLayout;  // KB

import controlP5.*;

public float noiseThreshold = 0.1;
public float zscale = 130;
public float zskew = 24; 
public int renderDetail = 2;

ControlFrame controlWindow;  // KB 18 Feb 2014
ControlP5 cp5;

boolean takeScreenshot;

void setupControls() {
  cp5 = new ControlP5(this);
  
  // by calling function addControlFrame() a
  // new frame is created and an instance of class
  // ControlFrame is instanziated.
  //controlWindow = addControlFrame("controlWindow", 350, 128);
  controlWindow = addControlFrame("Decoding Parameters", 350, 128);
//  controlWindow.setTitle("Decoding Parameters");

}

String getTimestamp() {
  return day() + " " + hour() + " " + minute() + " " + second();
}

// the ControlFrame class extends PApplet, so we 
// are creating a new processing applet inside a
// new frame with a controlP5 object loaded
public class ControlFrame extends PApplet {

  int w, h;

   // This has to be in it's own frame/window so the controls don't rotate

  // These handler functions need to be inside the ControlFrame class
  // in order to handle the callbacks from the new frame
  void noiseThreshold(float newThreshold) {
    if(newThreshold != noiseThreshold) {
      noiseThreshold = newThreshold;
      update = true;
      //println("Updated!!");  // KB
    }
  }
  
  // This is the handler function for zscale
  // Added by KB 2/2014
  void zscale(float new_zscale) {
    if(new_zscale != zscale) {
      zscale = new_zscale;
      update = true;
    }
  }

  // This is the handler function for zskew
  // Added by KB 2/2014
  void zskew(float new_zskew) {
    if(new_zskew != zskew) {
      zskew = new_zskew;
      update = true;
    }
  }

  // This is the handler function for renderDetail
  // Added by KB 2/2014
  void renderDetail(int new_rD) {
    if(new_rD != renderDetail) {
      renderDetail = new_rD;
      update = true;
    }
  }

  // KB 2/2014
  void screenshot() {
  takeScreenshot = true;
  }

  // KB 2/2014
  void exportCloud() {
  exportCloud = true;
  }

  // Moved into child window by KB 2/2014
  void exportMesh() {
  exportMesh = true;
  }
  
  public void setup() {
    size(w, h);
    frameRate(25);
    cp5 = new ControlP5(this);
    //cp5.addSlider("abc").setRange(0, 255).setPosition(10,10);
    //cp5.addSlider("def").plugTo(parent,"def").setRange(0, 255).setPosition(10,30);
      int y = 20;
    // Code moved into child window by VS 2/2014
    cp5.addSlider("noiseThreshold", 0, 1, noiseThreshold, 10, y += 10, 256, 9).setWindow(controlWindow);
    cp5.addSlider("zscale", -256, 256, zscale, 10, y += 10, 256, 9).setWindow(controlWindow);
    cp5.addSlider("zskew", -64, 64, zskew, 10, y += 10, 256, 9).setWindow(controlWindow);
    cp5.addSlider("renderDetail", 1, 4, renderDetail, 10, y += 10, 256, 9).setWindow(controlWindow);
    cp5.addBang("screenshot", 10, y += 10, 9, 9).setWindow(controlWindow);
    cp5.addBang("exportCloud", 80, y, 9, 9).setWindow(controlWindow);
    cp5.addBang("exportMesh", 160, y, 9, 9).setWindow(controlWindow);   
  }

  public void draw() {
  }
  
  private ControlFrame() {
  }

  public ControlFrame(Object theParent, int theWidth, int theHeight) {
    parent = theParent;
    w = theWidth;
    h = theHeight;
  }


  public ControlP5 control() {
    return cp5;
  }
  
  ControlP5 cp5;

  Object parent;  
}


ControlFrame addControlFrame(String theName, int theWidth, int theHeight) {
  Frame f = new Frame(theName);
  ControlFrame p = new ControlFrame(this, theWidth, theHeight);
  f.add(p);
  p.init();
  f.setTitle(theName);
  f.setSize(p.w, p.h);
  f.setLocation(100, 100);
  f.setResizable(false);
  f.setVisible(true);
  return p;
}
