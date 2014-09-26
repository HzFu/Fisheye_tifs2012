
This demo is about the paper: "Forgery Authentication in Extreme Wide-angle Lens Using Distortion Cue and Fake Saliency Map" 
in IEEE Transactions on Information Forensics and Security (T-IFS), vol. 7, no. 4, pp. 1301-1314, 2012. 
This code is implemented and tested in Matlab 7.8.0 and 7.10.0. 

This code only includes the fake saliency detection.

This file will show you:
1. how to run the demo;
2. explaination on the files.

-------------------------------------------------------------------------------

HOW TO USE

run the 'Demo_saliency.m'. 

There are 8 examples in "./ForensicImage" file. 
Change the image path for more demos:
"savefile = 'ForensicImage/example';"

Each image file includes:
example-org.jpg: The original image.
example.jpg: The faked image.
example.mat: The data of faked image, which includes:
   Points: the points of the candidate line.
   fish_x, fish_y, fish_r: the center and radius of fisheye image. 
   line_number: the number of candidate line.


-------------------------------------------------------------------------------

FILE EXPLANATIONS

 ForensicImage      : directory holding demo image and mat.
 Demo_Saliency.m : demo and obtaining the fake saliency map.
 Volume_inv.m       : computing the volume cue.
 Distance_inv.m     : computing the distance cue.
 Combine.m           : computing the combine cue.
 Line2image.m       :Add saliency weight of a line into the fake saliency map.
   
-------------------------------------------------------------------------------
