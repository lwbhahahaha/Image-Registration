# Project Overview
This repo wraps the [Nifty Reg](http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg). All credits go to original authors from [CMIC](http://cmictig.cs.ucl.ac.uk/wiki/index.php/Main_Page) and UCI Imaging Physics Laboratory.

The current release of `Nifty Reg` removed the support for GPU. So this project can be run without any CUDA toolkit or Nvidia GPUs.

**On a PC with the Intel 13900k CPU, the average running time to register one acquisition(v1 and v2) is ~800 seconds.**

# Installation Instruction
To install this program, follow the below steps.

## Step 1(Optional)
Install git from [this link](https://git-scm.com/download/win). Select "Standalone Installer" -> "64-bit Git for Windows Setup"
<p align="center">
  <img src=".\libs\readme_files\1.png" />
</p>

Run "Git-*****.exe" and click "next" until installation is done.

## Step 2
Create a new folder on desktop. For example, a folder called "registration"
<p align="center">
  <img src=".\libs\readme_files\2.png" />
</p>
Click the "Microsoft" icon (i.e. start button) from left down corner and type "cmd". Hit "Enter" on keyboard to run command prompt.
<p align="center">
  <img src=".\libs\readme_files\3.png" />
</p>

## Step 3
Type "cd /d PATH_TO_YOUR_FOLDER" and hit "Enter" on keyboard to run this command, where `PATH_TO_YOUR_FOLDER` should be replaced with the path to folder that you craeted in step 2. For example:
<p align="center">
  <img src=".\libs\readme_files\4.png" />
</p>
Type `git clone https://github.com/lwbhahahaha/Image-Registration.git` to download the source files from Github repo. Wait until the download is finished.
<p align="center">
  <img src=".\libs\readme_files\5.png" />
</p>
Now you can close the command prompt window.

## Step 4
Navigate to the folder you created in step 1. Now you should have the following files in the folder.
<p align="center">
  <img src=".\libs\readme_files\6.png" />
</p>
Click on `Setup.bat`. You will notice two new folders got created in this folder. Now the installtion proces is finished.


# Run Instruction
To run this program, follow the below steps.
## Step 1
Copy and paste the acquisition that has zero (or almost zero) motion inside the `reference_acq` folder. You should put ONLY ONE acquisition here as the reference(master) acquisition.
<p align="center">
  <img src=".\libs\readme_files\7.png" />
</p>
Copy and paste the acquisitions that have motions and need to be registered inside the `with_motion` folder. You can have one or more acquisitions here but all acquisitions MUST have a same BB(ROI bounding box) as the reference(master) acquisition.
<p align="center">
  <img src=".\libs\readme_files\8.png" />
</p>

## Step 2
Navigate back to the root folder and open `Batch_RunRegistration_wenbo_06052023.m` with Matlab. Select `libs` folder on the left and select `Add to Path` -> `Selected Folders and Subfolders`.
<p align="center">
  <img src=".\libs\readme_files\9.png" />
</p>

## Step 3
Edit `BB` at the 7-th line of code to your desired BB values. Quote from Logan Hubbard: BB stands for "Bounding Box." This takes a bit of explaining. As an example, for our cardiac data, the images were 512 x 512 x 320 voxels in dimension. Rather than registering all voxels between images, the images were cropped with a smaller 3D bounding box to include only the heart while excluding voxels of adjacent erroneous structures that we didn't want to waste computation time registering. The structure of the BB is [Xmin, Ymin, Zmin, Xmax, Ymax, Zmax]. For the critical limb data, if you don't want to crop the data with a BB since you're not registering that many volumes, then just use the whole volume by plugging in the indices as [1, 1, 1, size(vol,1), size(vol,2), size(vol,3)] and that should vocer it.
<p align="center">
  <img src=".\libs\readme_files\10.png" />
</p>

## Step 4
Hit `Run` button to run this matlab code. You should see the following output in command window, which shows that all acquisitions are successfully located by the program.
<p align="center">
  <img src=".\libs\readme_files\11.png" />
</p>
Now you should wait until the program to finish.

# Retrive Result
For example, to retrive the registered images for study `Flow20_acq1`, you should navigate to `with_motion` -> `Flow20_acq1` -> `REGISTERED` -> `reg`. You should see two `****.nii` files. These are the registered images for v1 and v2 in Nifty format. If you don't see these files, contact Wenbo for a solution.

(Wenbo is still developing part of the code to 1. convert the outputs to DICOM format; 2.align the orientation to match the orignal input images.; This Github repo and README will be updated.)