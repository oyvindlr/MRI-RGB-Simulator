# Simulating MRI using RGB-photos as phantoms
This project consists of a simple MRI-simulator written in Matlab, and a MATLAB GUI to use the library with any RGB color image. The color channels R, G and B are encoded into T1, T2 and proton density properties. The idea is to recreate the color image using MRI-sequences with different weighting. Students can play around with simulations to get a feel with the different properties.
One important reason to play around with simulations is to study MRI artifacts. At the moment, it is possible to study effects that are due to T1 and T2, as well as TE, TR, ɑ, and resolution. Other artifacts, specifically those that are due to noise, inhomogeneity of the magnetic field, mismatched field-of-view, and difference in Larmor frequency, are currently not implemented. Anyone interested is encouraged to contribute to such implementation.

The two parts of this code are, briefly: 
-   A general MRI-simulator which produces the complex MRI output signal given 2 or 3-dimensional input data consisting of voxels with properties T1, T2 and ⍴. The simulator needs an MRI sequence as input. Functions are provided  for generating spin-echo and gradient-echo sequences, but functions for any other kind of sequence can be created by anyone familiar with Matlab.
    
-   A graphical user interface (GUI) which uses the simulator. The RGB-channels in any digital image is encoded into properties T1, T2 and ⍴. One can then use the GUI to attempt to recreate the image by three different MRI-sequences with weighting of the different properties.


## MRI Simulator

The principle of the MRI simulation is relatively simple. A set of voxels is supplied to the simulator. Each voxel has the properties T1, T2, proton density, and spatial coordinates x, y, and z. In addition, a description of an MRI sequence is supplied to the simulator. The sequence contains descriptions of timing and strength of the B1 signal, magnetic field gradients in the x, y and z-directions and signal recording periods.

Each voxel is then processed independently: the samples from each recording event becomes a new line in k-space, until the full matrix has been built. Finally, the matrices produced by each voxel are added together to form the signal which is read at the MRI-machine’s input coils. This k-space matrix is transformed to the final grayscale image by an inverse 2D Discrete Fourier Transform (DFT). The number of input voxels is entirely independent from the number of output voxels.

The signal from each voxel is produced by the precession of the magnetization vector in that voxel - the complex output consists of the x and y coordinates of the magnetization vector at each sample time. In order to calculate this precession, the simulator must solve the modified Bloch-equations. This is very processor-intensive, therefore a few optimizations have been made. Firstly, everything is simulated in the well-known rotating reference frame. Thus, the magnetization vector does not precess unless a signal is applied on top of the B0-field, either B1 (in the x/y plane) or a gradient (which changes the z-direction component of the magnetic field). Secondly, the Bloch-equations are only solved when a change in the magnetic field occurs, or when a sample is being recorded. A change in the magnetic field will occur when either a gradient or the B1-signal is switched on or off.

For simplicity of implementation, the B1-signal must be a constant in the rotating reference frame - in other words, the B1-signal’s frequency must be exactly the Larmor-frequency. This means that a change in B1 frequency cannot be used for slice selection. Instead, a constant can be added to the z-direction magnetic field together with the z-gradient (or another one of the gradients, if slice selection should be performed in a different direction). This has the same effect as changing the B1-field’s frequency.

The full simulation is still very processor-heavy, with a running time proportional to the number of input voxels times the number of output voxels. However, since each input voxel can be processed independently, the simulator makes use of Matlab’s parallel processing capabilities to utilize all the computer’s processors and cores. This will only work if the parallel computing toolbox is installed.
## Graphical User Interface

The GUI was built on top of the simulator in order to simplify the application that this project focuses on, namely processing of RGB-images.

The GUI was built using Matlab’s “App Designer” . The interface consists of three main parts: Input definition, MRI settings and the output viewer.

![](https://lh3.googleusercontent.com/pxCphP8gskvNCWDG2e3vhgu81LrhFP5szzt1NKDh2XSPxPfp9meWKZ_b0C-e69VsrBRIfJLNmnocLdGSoyNEBzTtj4D1doHhzQ53oIwfmiG3A9OLM4jCLsSE7WO2s2_TqUhF6BMB)

Figure 1: The graphical user interface (GUI)

### Input definition

This section lets you select an image to be used as input to the simulation. Recall that the processing time is proportional to the number of pixels, so make sure you pick an input image with a reasonable resolution; an image with a resolution of 1000x1000 will take 100 times longer to process than one with a resolution of 100x100 pixels! The “show channel” control lets you choose between viewing the image in full color, in black/white (where the grayscale value is the average of each of the R/G/B channels) or see a single channel (R, G, or B) as a grayscale image. The “advanced” button lets you define how the image’s pixel values are converted to T1, T2 and proton density values, as well as the physical size of each pixel (see figure 2).

The proton density value will be directly proportional to the pixel value of the selected channel. The T1 and T2 values are encoded as a chosen constant number of milliseconds, plus or minus a chosen percentage of this constant. The actual value is computed from the pixel values of the selected channel, such that the central pixel value (e.g. 128 in a 8-bit image) is equal to the selected constant.

The image size in the x-direction (left-right) is the “real life” size of the image in the x-direction. Each pixel is assumed to represent a square, therefore the y-dimension is given by the x-dimension and the relative number of pixels in the x and y directions.

Note, however, that the size setting will not affect the output at the moment, because the field-of-view of the MRI-image is automatically adjusted to be the same as the input image size. The control is included in case this should change in a newer version.

  

![](https://lh5.googleusercontent.com/gCBsENsx-xGz2tLDPB2CxLpYyDfoyKDNtQwlWJICmjy4LuleMnAM7EmO-N2jNyEaT9XFZJW0mov3WHSPZplF_zuWXxMJPV1SrtVZ503bIbB4aXab44lEZ01T9kpEfKfTc39gFggZ)

Figure 2: Advanced settings

  

### MRI settings

This section sets up your virtual MRI-machine and the MRI-sequence. The first settings have to do with magnetic field strength - these settings are used in the simulator, but, as long as they are appropriate, they will only affect signal-to-noise ratio. And since no noise is added in the GUI at the moment, changing them will not actually have an effect.

The next setting is the output resolution in pixels, where x is left-right, and y is up-down. The resolution can be set entirely independently of the input resolution. However, a higher output resolution than input resolution does not really make sense, as there is no information available “between” input pixels. Note also that the processing time is proportional to the number of output pixels (as well as the number of input pixels), so keep these numbers small to keep processing time reasonable.

Next, a switch lets you choose between running a single MRI-sequence or one sequence for each RGB-channel. When running three sequences this way, the idea is that the settings for each sequence differ: One sequence should be T1-weighted, one should be T2-weighted and one should be proton density-weighted. This should correspond to the sources for T1, T2, and proton density in the input definition settings.

  

![](https://lh4.googleusercontent.com/pMhWIO-buQEJPlBXfvPn_LXSgtPkjzeCvznl2ofbZUv11-X4JIfA_uiRdqrJs34daxImdvMpxVu56VnuduC3xq4z8QLNs1hx5lm2YkWDIRKBlDzR56DcNgikIu-hv_rDo-SfAJI1)

Figure 3: MRI settings

### Output viewer

The output view shows the simulated MRI-image. If “single sequence” was selected in the MRI settings, a grayscale picture will be shown, and no output controls are available. If a set of RGB-sequences were selected, the controls shown below will be available. The “show channel” dropdown gives the same choices as the one in the input definition, either see the full color image or the individual RGB-channels in grayscale.

The weighting in your MRI settings lets you give more weight to T1, T2, or proton density in the R, G, and B channels. However, the relative intensity between the three channels cannot be retrieved this way. Therefore, the GUI lets you give higher or lower weights to the individual channels in the shown image. You can play around with these settings until you are satisfied, or perhaps try to match the intensity of each individual channel by viewing them in both the input and output view.

Note: When you run the RGB sequence, the output you see for the proton density coded channel will be the exact output produced by the simulator. However, for the T1 and T2 coded channels, the output is divided by the proton density channel output before it is shown. This is because proton density will be a factor in all sequences, so we attempt to remove the proton density dependence to get back to a “pure” T1 or T2 view.

In order to view the actual output of a T1 or T2 weighted sequence, you should run this sequence as a “single sequence”.

  

![](https://lh3.googleusercontent.com/u3034CnwAYy9PWXcPPyJvDSKc5uj3JsoBemPl4JhR9wpmQYYNAz6hxWos1rEqGKVz3MJLF-M3671pxgNADjnZMCdmMVYkiaURpVuIKslSyaqdk38RH5g9dsWFyzqyXFvBTVS7mA-)

Figure 4: Output view

## Possible future improvements
Some artifacts could be relatively easily implemented in the GUI, such as the addition of white noise or periodic noise, or a mismatch in field-of-view. Some of the more interesting artifacts are, however, those that are caused by heterogeneous susceptibility and the difference in Larmor frequency between water and fat. Implementing these in the simulator would be relatively easy, but including them in the GUI is maybe not as straightforward.

For example, varying B0 over the phantom while using a lower output resolution than input resolution, would cause intra-voxel decorrelation and therefore a T2*-effect. But this would complicate the phantom definition - we need a 4th channel to encode the B0 inhomogeneity. One possibility could be to keep one of the other properties constant when varying B0.
