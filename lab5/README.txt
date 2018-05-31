--------------------------------
LAB 5: HEX TO DECIMAL CONVERSION
CMPE 012 Spring 2018

Joseph Csoti, jcsoti
Section 01D, Rebecca + Carlos
--------------------------------


----------------
LEARNING

I learned that takling this project was a big task. I wished that I had started earlier.

Though this helps confirm my theory of incremental programming. Yo shouldnt try to code bottom-up,
but rather top-down. First code small parts an even hardcode some parts. Then slowly replace those parts
and expand them.

----------------
ANSWERS TO QUESTIONS

1.
There are two represenations of "0" in my input number:
  The first is the VALUE of zero or 0x00000000
  The second is the "char" 0 such as 0xF0F0F0F0

2.
Largest input: 2^31 - 1 = 2147483647
This is because we use 32 bits to store the result and use two's complement

3.
Smallest input: - 2^31 = -2147483648
This is because we use 32 bits to store the result and use two's complement

4.
We used signed arithmetic for this program because of the fact that our numbers is stored in two's complement
That means that the first bit is used to signify the magnitude (0=pos, 1=neg)

However the differnce in mips is not much:

With signed arithmetic can generate an OVERFLOW,
while unsigned can NOT

A disadvantage for using signed is that it's harder to convert to ASCII. Since it's a "negative" number
we have to make it positive and add 1

5.
Binary to decimal converter:

The code would basically be the same expect for so numbers (like # to shift)
Input: ASCII "1010101"

And you would have to decide wether or not you are are gonna use an unsigned number or signed.
If you choose signed, you must account for the first bit being the maginitude and not count it
as a value