# Project Overview
This repo wraps the [Nifty Reg](http://cmictig.cs.ucl.ac.uk/wiki/index.php/NiftyReg). All credits go to original authors from [CMIC](http://cmictig.cs.ucl.ac.uk/wiki/index.php/Main_Page) and UCI Imaging Physics Laboratory.

The current release of `Nifty Reg` removed the support for GPU. So this project can be run without any CUDA toolkit or Nvidia GPUs.

**On a PC with the Intel 13900k CPU, the average running time to register one acquisition(v1 and v2) is ~40 minutes.**

(Wenbo is still developing part of the code; This Github repo and README will be updated.)

# Installation Instruction
To install this program, follow the below steps.

## Step 1

Click on `Code` (The green button on this page), then select `Download ZIP`. Unzip this program to a location of your choice. You should **NOT** unzip this folder to a remote location(the shared drive), but to your local drives. The speed of read and write files will be reduced significantly if you unzip this program to the shared drive.
<p align="center">
  <img src=".\program_files\readme_files\1.png" width="75%">
</p>

## Step 2
Go to [Julia download page](https://julialang.org/downloads/) and download Julia. You should download the **64-bit installer**. Version v1.9.1 is prefered. Other versions of Julia may raise compatibility issues. Run the installer. **Make sure to select "Add Julia to PATH".**
<p align="center">
  <img src=".\program_files\readme_files\2.png" width="60%">
</p>

## Step 3
Navigate to the unzipped folder and run `setup` or `setup.bat`. If you are intalling this program for the first time, it might take up to 5 minutes to finish. You should notice some new folders are created after the installation.
<p align="center">
  <img src=".\program_files\readme_files\3.png" width="40%">
</p>

# Run Instruction
To run this program, follow the below steps.

## Step 1
Copy and paste the acquisition that has zero (or almost zero) motion inside the `.\input\reference_acq` folder. You should put ONLY ONE acquisition here as the reference(master) acquisition.
<p align="center">
  <img src=".\program_files\readme_files\4.png" width="60%">
</p>

Copy and paste the acquisitions that have motions and need to be registered inside the `.\input\with_motion` folder. You can put one or more with-motion acquisitions here.
<p align="center">
  <img src=".\program_files\readme_files\5.png" width="75%">
</p>

## Step 2
Navigate back to the main folder and run `run` or `run.bat`. You should see the following output in command window, which shows that all acquisitions are successfully located by the program. Now you should wait until the program to finish.
<p align="center">
  <img src=".\program_files\readme_files\6.png" width="75%">
</p>

# Retrive Result
You should see the following output in the command window, which shows that the program finished running.
<p align="center">
  <img src=".\program_files\readme_files\7.png" width="75%">
</p>

To retrive the registered images, navigate to the `output` folder.

