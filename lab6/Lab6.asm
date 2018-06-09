# Lab6.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01H, Carlos
# =============

# REGISTERS USED
# $t0 = COPY of INPUT
# $t1 = sign
# $t2 = expo
# $t3 = mant

# MACROS

# Taken from test_Lab6.asm (author: mrg)
.macro print_str(%label)
	la $a0, %label
	li $v0, 4
	syscall
.end_macro
# Taken from test_Lab6.asm (author: mrg)
.macro print_int(%register)
	move $a0, %register
	li $v0, 1
	syscall
.end_macro

# splits a float into 3 different registers
.macro split_float(%src, %dst, %r1, %r2, %r3)
  move %dst, %src

	andi %r3, %dst, 0x7FFFFF   # Store mantissa
  srl %dst, %dst, 23          # shift to move mantissa

  andi %r2, %dst, 0xFF       # store expo
  srl %dst, %dst, 8           # shift to move expo

  andi %r1, %dst, 0x1        # store bit
.end_macro

# %length is = Length-1
.macro print_bitstr(%register, %length)

  li    $t8, 1 # constant
  li    $t4, 1 # mask with bit is LSB
  li    $t9, %length # counter

  sll   $t4, $t4, %length # move bit to MSB

  loop:
    beqz  $t4, end
    and   $t5, $t4, %register # store bit in $t5
    srlv  $t5, $t5, $t9 # move bit to RIGHT
    srl   $t4, $t4, 1

    beqz  $t5, is_zero
    beq   $t5, $t8, is_one

    j loop
  is_one:
    print_int($t8)
    sub $t9, $t9, 1
    j loop
  is_zero:
    print_int($zero)
    sub $t9, $t9, 1
    j loop
  end:
.end_macro

.macro compare_reg(%result, %a, %b)
  beq %a, %b, is_equal
  bgt %a, %b, is_great

  is_less:
    li %result, -1
    j end_comp
  is_great:
    li %result, 1
    j end_comp
  is_equal:
    li %result, 0
  end_comp:
.end_macro

.data
  str_sign: .asciiz "SIGN: "
  str_expo: .asciiz "\nEXPONENT: "
  str_mant: .asciiz "\nMANTISSA: "

.text

# Subroutine PrintFloat
# Prints the sign, mantissa, and exponent of a SP FP value.
# input: $a0 = Single precision float
# Side effects: None
# Notes: See the example for the exact output format.

  # Floating point Number
  # 0           10111101    00010100000011001110111
  # (sign 1b)   (expo 8b)   (mantisa 23b)

PrintFloat:

  split_float($a0, $t0, $t1, $t2, $t3)

  print_str(str_sign)
  print_int($t1)

  print_str(str_expo)
  print_bitstr($t2, 7)

  print_str(str_mant)
  print_bitstr($t3, 22)

  jr $ra

# Subroutine CompareFloats
# Compares two floating point values A and B.
# input: $a0 = Single precision float A
# $a1 = Single precision float B
# output: $v0 = Comparison result
# Side effects: None
# Notes: Returns 1 if A>B, 0 if A==B, and -1 if A<B
CompareFloats:

  split_float($a0, $t0, $t1, $t2, $t3)
  split_float($a1, $t4, $t5, $t6, $t7)

  compare_reg($t8, $t1, $t5) # compare sign bit
  sub $t8, $zero, $t8  # $t8 is "flipped": -1 => 1, 1 => -1, 0 => 0
  compare_reg($t9, $t2, $t6) # compare expo
  compare_reg($t0, $t3, $t7) # compare mantissa

  #beqz $t8, compare_value # signs are the same
  move $v0, $t8

  jr $ra

compare_value:

  # since I dont have time, I'm going only to compare the mantissa or $t0
  
  # Since both are assumed negative or postive, I can just check 1 reg
  # if neg, the answer needs to be "flipped" bc -6 < -2, but abs(-6) > abs(-2)
  bltz $t0, flip_value
  move $t8, $t0
  jr $ra

flip_value:
  xori $t8, $t8, 0x1
  jr $ra

# Subroutine AddFloats
# Adds together two floating point values A and B.
# input: $a0 = Single precision float A
# $a1 = Single precision float B
# output: $v0 = Addition result A+B
# Side effects: None
# Notes: Returns the normalized FP result of A+B
AddFloats:
  jr $ra

  # to make it same exonet just shift it the same amount

# Subroutine MultFloats
# Multiplies two floating point values A and B.
# input: $a0 = Single precision float A
# $a1 = Single precision float B
# output: $v0 = Multiplication result A*B
# Side effects: None
# Notes: Returns the normalized FP result of A*B
MultFloats:
  jr $ra

  # just nomrlaize mfhi
  # a1 = high?
  # a2 = low?

# Subroutine NormalizeFloat
# Normalizes, rounds, and “packs” a floating point value.
# input: $a0 = 1-bit Sign bit (right aligned)
# $a1 = [63:32] of Mantissa
# $a2 = [31:0] of Mantissa
# $a3 = 8-bit Biased Exponent (right aligned)
# output: $v0 = Normalized FP result of $a0, $a1, $a2
# Side effects: None
# Notes: Returns the normalized FP value by adjusting the
# exponent and mantissa so that the 23-bit result
# mantissa has the leading 1(hidden bit). More than
# 23-bits will be rounded. Two words are used to
# represent an 18-bit integer plus 46-bit fraction
# Mantissa for the MultFloats function. (HINT: This
# can be the output of the MULTU HI/LO registers!)
NormalizeFloat:
  jr $ra

  # find leading "1" , that is hidden bit, so skip it
  # then count 23 bits, then truncate

  # use mask to find bit, set counter, to find bit position
  # OR use CLZ to count leading zeros

  # the OR togetheer

# HELPER FUNCTIONS