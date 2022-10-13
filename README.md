## Conventional Beamforming

# Setups
* Install Matlab 
* Clone the repo
* From `APPS/Get More Apps` Install Phased Array System Toolbox
* Run `Conv_BF_main.m`

# Introduction
In this section you can see the result of Conventional BF that is implemented in Matlab.
You can see that as the resolution of the phase-shifter increased, the better the BF becomes. Also,you can see that here that sidelobes grow, thus it reduces the performance
of interference suppression. In Figure 1.2 you can see the result of the ideal and quantized weights for 45 degree phaseshift. You can see that the difference between these two
patterns is obvious. The quantized weights (red line) in figure are for the weights that
I have after implementing conventional BF and quantized them based on the resolution
of the phase-shifter I want. 45-degree resolution means that I want to transfer the data
with only 4 bits. In other word the phase shift is based on these 4 bits. Actually each
column of the CB matrix specifies the phase shift of each antenna element. So, when you
transmit data with more bits, you increase the resolution of the phase-shifter, and the
quantized and ideal weights gets more like each other.In Fig. 1.3 you can see that the two
pattern start to start to look alike each other. In the next figures you can see this effect.
In Figure 1.1 you can see the resolution and the equivalent number of bits for transmitting
data
From Figure 1.2 to Figure 1.4 you can see that the difference between ideal and quantized
weights are decreasing as the number of bits increases.


Since Sivers EVK02001 use 6 bits to transfer data, our resolution would be 5.625 and you
can see this in Figure 1.4.
In the appendix section you can find more results for other phaseshift resolution.

# Results

![alt text](https://github.com/[username]/[reponame]/blob/[branch]/image.jpg?raw=true)


