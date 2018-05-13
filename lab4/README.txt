--------------------------------
LAB 4: FEEDBABE IN MIPS
CMPE 012 Spring 2018

Joseph Csoti, jcsoti
Section 01D, Rebecca
--------------------------------


----------------
LEARNING

I learned that assembly is hard, or to be more general low-level languages are. This program was just over 100 lines,
while in Java it could be done in just ~20. Java is also easier to read/write - It is almost like english. With assembly,
it can be hard to understand what your code does.

However, the same principles of "incremental" development still apply. By first figuring out hoe to print text, then do a loop,
take in input, and finally tieing everything together, it became not too difficult.

----------------
ANSWERS TO QUESTIONS

1. 
65535

We can calculate how big N can be:

MIPS uses 32 bits for its registers so it should be 2^32 - 1
However we used a "signed" number so this reduces it by half to 2^16 -1

So by theory we could input any number from

0 -> 2^16 - 1  or
0 -> 65535

What determines the limit is how big the registers are (MIPS is 32bit) and the fact we used signed, rather than unsigned

2.
After assembling the program, the "data" gets moved to the stack which has the range of address of:
0x7FFF - 0xFFFF

3.
Some of the instructions I used were pseudo instructions:
  li, la, move
The assembled instructions produce the right result by executing multiple and complex instructions.

4. 
I used a total of 11 registers. Yes I could have a lot fewer registers, by combining some and reusing some.
However, this would have made my code slightly less readable. For example, if I had to share 1 register for the remainder,
I would have to clear it everytime I wanted to divide. 

So yes, I could have had wrote mt program with fewer registers, but for this project I felt like having just enough to 
better understand what I was writing.