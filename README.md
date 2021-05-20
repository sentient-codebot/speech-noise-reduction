# speech-noise-reduction

mini-project of EE4182 Digital Audio and Speech Processing

### Project details:

* Design and build a single-channel speech enhancement (noise reduction) system for far-end noise reduction.

* Use matlab

* The speech enhancement system should consist of a gain function, noise PSD estimator and speech PSD estimator.

* Perform an evaluation of the speech enhancement system.

### Optional:

* Implement a multi-microphone system

## File description 

### main function

* main.m the main function which implements the whole noise reduction pipeline

### utility functions

* frame.m function to frame the original sound signal

* attach_frame.m function to overlap framed signals

* importfile.m  call MATLAB built-in functions to import any type of file. 
required by create_dataset.m. Need not running. 

* create_dataset.m import clean speech and add noise. Store resulted noisy speech to .mat. Need only running once. 
