--------------------------------
LAB 3: LOGIC UNIT WITH MEMORY
CMPE 012 Spring 2018

Joseph Csoti, jcsoti
Section 01D, Rebecca
--------------------------------

----------------
LEARNING

I learned that abstraction was very important. By breaking the project into smaller components, and doing each one, and then "linking" them together made the project much
easier. 

I also learned that creating optimized + easy to understand circuts is hard. Knowing what each part of your circut does can be tricky. I found that by labeling a lot, it made it much eaiser

----------------
ISSUES

One issue I had was where to start. It hard to jump in and find a starting point. What was helpful was
reading the document and adding the required components. 

Another issue I ran into was the output not being correct. For intance doing the example 4 OR A, would give the output "0" rather than "e"
after closer inspection,  I noticed that I did not implement an OR gate in my MUXES. After fixing that, my program worked

----------------
DEBUGGING

To debug I added various LEDS at various point in the program. For instance I put LED's at the output of each of the 4 muxes and flip-flops. That way I could verify the value that it was outputting the correct values.

To confirm that my program was working, I tried entering my own input and checking the 7-bit display

B AND 2 = 2
F AND 1 = f
6 OR 3  = 7

----------------
QUESTIONS

What is the difference between a bit-wise and reduction logic operation?
  There some difference between a bit-wise and a logic operation. A bitwise operation applies to each bit first
  For example: 
    0101 & 1100 = 0100
    1010 & 1111 = 1010
    1101 | 0100 = 1101
  However a reduction operator applies the operation AFTER, which means it could also be "short-circuted" 
    0010 && 1101 = 1 

What operations did we implement?
  We implemented the following operations:

  - AND: Performs an "AND" operation on the bit, both bits must be true. 0&0 = 0, 1&0 = 0, 1&1 = 1
  - OR: Performs an "OR" operation, any bit(s) can be true 0&1 = 1, 0&0 = 0, 1&1 = 1
  - STORE (Passthrough): No operation is really made, the value is just "passed" through
  - INVERT/NOT: Inverts the value, 0 -> 1, 1 -> 0

  Each of these operations was used in the 4 muxes + logic gates

Why might we want to use the other type of logic operations?
  Other operations that we could have used were XNOR and XOR logic gates. These could have been made by combining the above operations.
  By having these extra gates, we could have simplifed the muxes into a simplier and easier to understand circut.

  CPU makers do this as well to make more cost-effective processors.