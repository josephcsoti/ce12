--------------------------------
LAB 6: FLOATING POINT MATH
CMPE 012 Spring 2018

Joseph Csoti, jcsoti
Section 01H, Carlos
--------------------------------


----------------
LEARNING

I learned that MIPS has some "features" I missed from other OOP languages like "functions". Although in MIPS,
they are called "macros". They are still different however because after it gets compiled, the calls to the "macros" are
replaced with the macro itself. However, it makes it easier to program as you can create generic "functions/macros"
improving readablity

----------------
ANSWERS TO QUESTIONS

1.
I wrote more test cases to test each function more completely and cover each possible case.
For example I had 4 floats, instead of 2. They followed the format of
  Float A: (negative number)
  Float B: (positive number)
  Float C: (another negative number)
  Float D: (another positive number)
I then performed tests on the combinations of the 4 above (- & -), (- & +), (+ & +), etc..
By testing all combination, it ensured that the function works for all cases

For example the MultiplyFloats function, if given a (-) and (-) number, the result would be positive.
The orginal test fuile did not test this.

2.
A floating point overflow happens when there is too much data to represent.
The most common example of an overflow is when the exponent in a FP number is too high
the IEEE standard gives the exponent 8 bits, which means it can have values between 0-255 or (-128-127 (if signed))
When you try to set a value above the maxium or below the minium, you will get a OVERFLOW.

For intance if youm tried to create a FP# with an exponent of 280, thier is not enough bits to hold it, so the
extra bits just "overflow" into the other data (mantissa or sign)

The IEEE standard then dictates that the answer is set to :(+/-)infinity:

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