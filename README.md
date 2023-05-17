# MoCap_TaskIntegration
## Written by EK Klinkman
#### Some contributions by V Joshi, R Shafer, M Donlin
This is a collection of MATLAB scripts that were created for a motion capture setup in the University of Michigan MVD lab. 
The goal of this setup is to stream force plate data in real time to trigger a series of Psychtoolbox-based visual stimuli.
Base code [MVD_LeanShiftStepFull_20230207_EKK.m] does not run in its entirety; much of it does work (functions, QCM commands, participant checks) but it needs to be finished.

Code as of 05-16-2023 needs to be edited to include an external trigger, pull samples from QCM every n frames, store to temporary memory to use in Psychtoolbox task blocks (CoPAccel threshold), and then store all force, kinematic, eye tracking, and generated task data in a data structure and write to an excel file once the end of the data collection session is triggered. 
Modified CTSIB (m-CTSIB) task is incomplete; Limits of Stability (LoS) has not been written but sway angle calculations are included in [Calculations.pdf]. 

SETUP:
  7 AMTI force plates embedded into ground (analog signal already converted to digital and paired with Qualisys Track Manager (QTM) and able to be streamed directly from QTM),
  18-camera Qualisys motion capture system (QTM),
  PupilLabs glasses (code does not yet exist) (PupilCapture).
  
DESCRIPTION:
  Participant stands on force plate. Force data read in real-time from Qualisys to MATLAB (Psychtoolbox (PTB)). If CoP Acceleration (CoPAccel) is over a certain threshold, do nothing. If under threshold, trigger change in PTB stimulus display - Lean, Weight-Shift, Step, m-CTSIB, LoS. 
