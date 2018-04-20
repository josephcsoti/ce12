/*------------------------------------------------
File Name: README.txt

Name:   Joseph Csoti
Email:  jcsoti@ucsc.edu
CruzID: jcsoti
ID:     1617438
Class:  CMPE 12 - 01D Rebecca

Assignment: Lab #2 - Introduction To Logic With Multimedia Logic
Due Date:   05/20/18
------------------------------------------------*/

Contents:
  lab2/
    Lab2_tutorial.lgi
    Lab2.lgi
    README.txt

Notes: None

===========
Lab Report
===========

Q: How would you make your own 7-segment display from Part B if you didn’t have one in MML?
A: I would make one by having 7 LED's. This "unit" would be connected to some sort of logic that has 4 inputs.
4 inputs because 2^4 -1 = 15, which is enough space for all numbers (0-9) and some letters (A-F). To make it display what you 
want, you just supply power to the right inputs 

Q: How do you think the random number generator works?
A: I think that the RNG has an internal clock, that when given power (Button press to C+), 
picks a number of wires to turn "on" and the rest "off"

Q: How can things be really random in a computer when it is made of logic gates, which are supposed to be deterministic?
A: A "random" number in a computer is not possible. A computer could only generate a "pseudo-random" number. 
It does this by having a preset "seed" number that it performs complex math on. The answer is then again put through the math function.
But eventually it would repeat as the RNG spits out the same "seed" it was given, making a "pattern" emerge.
So the "random" number can only be as random, as the "seed" is.