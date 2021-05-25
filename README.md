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

### runnable functions

* main.m the main function which implements the whole noise reduction pipeline

* histogram_freq_domain.m shows the histogram of the clean speech DFT coefficient magnitudes, and also tries to fit a distribution, although not really contribute for later work. 
* s_mag_prior_distribution.m trying to use MLE to get the distribution of the clean speech signal[currently not used]
* plot_ggd.m shows what the generalized gamma distribution density function looks like

* bartlett_estimate.m as the name suggests

### key utitily functions
* noise_track.m MMSE based noise PSD tracking algorithm with SPP

* mmse_gain.m an attempt to calculate MMSE gain (under rayleigh distribution). [currently not working]

* noisepowpropsed.m Richard's script. the EXACTLY same function is implemented in noise_track.m [currently not used]

### trivial utility functions

* frame.m function to frame the original sound signal

* attach_frame.m function to overlap framed signals

* importfile.m  call MATLAB built-in functions to import any type of file. 
required by create_dataset.m. Need not running. 

* create_dataset.m import clean speech and add noise. Store resulted noisy speech to .mat. Need only running once. 

* lookup_gain_in_table.m Richard's script. Used to look up gain function values from a given table

* 
* 
