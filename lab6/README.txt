--------------------------------
LAB 6: FLOATING POINT MATH
CMPE 012 Spring 2018

Joseph Csoti, jcsoti
Section 01H, Carlos
--------------------------------


----------------
LEARNING

<<Describe what you learned, what was surprising, what worked well and what did not.>>


----------------
ANSWERS TO QUESTIONS

1.
<<Insert your answer>>

2.
<<Insert your answer>>

3.
Yes rounding is an very important part of floating point numbers, since they tend to not be accurate.

For intance, due to the way that we round 0.1
  DEC: 0.1
  FLOAT: 0.100000001490116119384765625
We dont get a perfect representation

I did not have enough time to implement rounding, so sometimes my answers were off.

Though if I had more time I would do it like this:

in NormaliseFloats, after storing the 23 bits of the mantissa, I would check the next bit.
If the next bit were to be:
  1 => round up the mantissa
  0 => round down, or keep the same mantissa

4.
Yes I wrote some additonal functions:

split_float:
  - Given a float, it will seperate it into its 3 parts and store each into a different register
  - for example $t0 = sign, $t1 = exponent, $t3 = mantissa

print_bitstr:
  - Given a bitstring and it's length, it prints out its ascii representation
  - It does this by isolating each bit, and depending on if its 0 or 1, print the correct int

compare_reg:
  - Given 2 registers, it compares them.
  - if a = b then it returns 0, a>b returns 1, if a<b return -1

1. What	additional	test	code	did	you	write?		Why?		
2. What	is	floating	point	overflow?	Provide	an	example.	
