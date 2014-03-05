### Notes:
You must manually select the screen capture size, the camera, and the serial port (if you are using this with an MSP430 Launchpad).

To set the serial port, find the following code block and follow the instructions in the comment:
	  // You need to run the program once to generate a list of available serial ports.
	  // Then change the "index" of Serial.list()[index] to match the port your Launchpad is attached to 
	  println(Serial.list());
	  myPort = new Serial(this, Serial.list()[1], 9600);

##### Remember that the "index" value must match the array index of the serial port you want to use, not the serial port number itself. i.e. if your ports look like this:  
COM1  
COM2  
COM7  
The array value you want to use for COM7 is "2", not "7"  

To set the camera, find the following code block and follow the instructions in the comment:
	 // The camera can be initialized directly using an element
	 // from the array returned by list():
	 cam = new Capture(this, cameras[0]); 
	 // Or, the settings can be defined based on the text in the list
	 //cam = new Capture(this, 640, 480, "Built-in iSight", 30);

Also make sure the size of your display window matches the camera image. The following line of code sets the display window size:  
	  size(640, 480);  // Size of capture window needs to match resolution of the camera


### Known issues:

##### Win7/Win8 Exceptions
If you want to run this code in  Win7 or Win8 using a standard install of Processing 2.1.1, your code will throw the following exceptions:

   	JNA: Callback org.gstreamer.elements.AppSink$2@7d1f4fe threw the following exception:  
   	java.lang.ExceptionInInitializerError
  
Please implement the following workaround:
Replace the following files in Processing 2.1.1 with versions from Processing 2.1.0 or 2.0.3:
	
>gstreamer-java.jar  
>jna.jar

These files can be found in the directory:

  \modes\java\libraries\video\library
  
This workaround is discussed here:
https://github.com/processing/processing/issues/2327
