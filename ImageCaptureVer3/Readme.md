### Known issues:

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

