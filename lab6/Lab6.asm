# Lab6.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01H, Carlos
# =============

# --- PSEUDOCODE ---
# print_str()
# 	syscall 4
# print_int()
# 	syscall 1
# split_float()
#   store mantissa
#   shift 23 bits
#   store mantissa
#   shift 8
#   store expo
#   store sign
# print_bitstr()
#   Create mask bit in LSB
#   counter (starting from length)
#   move mask to MSB
#   loop:
#     BREAK if == 0
#     AND to see if 1 OR 0
#     shift to LSB
#     CHECK if == 0 OR 1, break to
#     j loop
#   is_one:
#     print "1"
#   is_zero:
#     print "0"
# compare_reg()
#   GOTO equal if a=b
#   GOTO greater if a>b
#   is_less:
#     result = -1
#   is_great:
#     result = 1
#   is_equal:
#     result = 0
# PrintFloat:
#   Split FP#
#   print pretext
#   print sign()
#   print pretext
#   print expo()
#   print pretext
#   print mantissa()
# CompareFloats:
#   split_float(A)
#   split_float(B)
#   r1 = compare_reg(sign part of A, sign part of B)
#     flip result
#   r2 = compare_reg(expo part of A, expo part of B)
#   r3 = compare_reg(mant part of A, mant part of B)
#   #beqz $t8, compare_value # signs are the same, so do more complex comparissons
#   move $v0, $t8 # store result
# compare_value:
#   Since both are assumed negative or postive, I can just check 1 reg
#   if neg, the answer needs to be "flipped" bc -6 < -2, but abs(-6) > abs(-2)
#   bltz $t0, flip_value
# AddFloats:
#   split_float(A)
#   split_float(b)
#   IF signs are same
#     SAME -- or ++
#       check if EXPONTENTS match
#          If dont match
#           Find offset
#             offset = sub $t9, $biggerEXPO, $smallerEXPO
#             shift HB.Mantissa by offset
#             slr $t8, $...
#     DIFF +-
#       Check if negative value is BIGGER than positive vale MAGNITUDE
#       result is negative
#       subtract smaller mag from bigger mag
#          if exponents dont match follow above procedure
#       add a (+/-) sign accordingly
#       Add together HB.Mantissa
#   Normalize & Round
# MultFloats:
#   a1 = high?
#   a2 = low?
#   ADD exponents together (bias becomes "doubled"). Subtract bias ONLY ONCE (-127)
#   MULT HB.Mantissa of both A & B
#   Keep track of signs
#     -*+ = +,  -*- = +
#   Normalize & round if necessary
# NormalizeFloat:
#   move sign bit
#   move mantiss part 1
#   move mantiss part 2
#   move expo
#   shift SIGN 31 bits
#   shift EXPO 22 bits
#   find leading bit
#   clz $t4, $t1
#   addi $t4, $t4, 1 # incriment one (b/c hidden bit) leading 1 is "hidden bit" so skip it. 
#   $t5 = load 23 bits from OFFSET
#     implement rounding if wanted
#     check the 24th bit and round accordingly (1 > round up, 0 > nothing or round down)
#   OR answer + sign
#   OR answer + expo
#   OR answer + mantissa
#   move answer
# --- END OF PSEUDOCODE ---

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
  move %dst, %src            # Copy FP #

	andi %r3, %dst, 0x7FFFFF   # Store mantissa
  srl %dst, %dst, 23         # shift 23 to move mantissa

  andi %r2, %dst, 0xFF       # store expo
  srl %dst, %dst, 8          # shift 8 to move expo

  andi %r1, %dst, 0x1        # store bit
.end_macro

# Prints a binary bit string: 011101010101
# $t4 = mask
# $t8 = 1
# $t9 = length
.macro print_bitstr(%register, %length)

  li  $t8, 1       # Used for printing
  li  $t4, 1       # Create mask bit in LSB
  li  $t9, %length # counter (starting from length)

  sll   $t4, $t4, %length # move mask bit to MSB

  loop:
    beqz  $t4, end
    and   $t5, $t4, %register   # AND to see if result is 1 or 0
    srlv  $t5, $t5, $t9         # move bit to RIGHT
    srl   $t4, $t4, 1           # move bitmask to RIGHT

    beqz  $t5, is_zero      # t ?= 0
    beq   $t5, $t8, is_one  # t ?= 1

    j loop
  is_one:
    print_int($t8)    # Print "1"
    sub $t9, $t9, 1   # i--
    j loop
  is_zero:
    print_int($zero)  # Print "0"
    sub $t9, $t9, 1   # i--
    j loop
  end:
.end_macro

# Compares reg A and B and writes result
# A = B: 0
# A > B: 1 
# A < B: -1
.macro compare_reg(%result, %a, %b)
  beq %a, %b, is_equal  # A == B
  bgt %a, %b, is_great  # A > B
  # At this point we know A < B, so no need to break if less than...
  # so we just move on to the next instruction

  is_less:
    li %result, -1    # write 1
    j end_comp        # break
  is_great:
    li %result, 1     # write 1
    j end_comp        # break
  is_equal:
    li %result, 0     # write 0
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
# $t0 = COPY of A
# $t1 = sign of A
# $t2 = expo of A
# $t3 = mant of A
PrintFloat:

  split_float($a0, $t0, $t1, $t2, $t3)  # split FP#

  print_str(str_sign)   # print "sign" pre_text
  print_int($t1)        # print sign value

  print_str(str_expo)   # print "expo" pre_text
  print_bitstr($t2, 7)  # print expo value

  print_str(str_mant)   # print "mant" pre_text
  print_bitstr($t3, 22) # print mant value

  jr $ra

# Subroutine CompareFloats
# Compares two floating point values A and B.
# input: $a0 = Single precision float A
# $a1 = Single precision float B
# output: $v0 = Comparison result
# Side effects: None
# Notes: Returns 1 if A>B, 0 if A==B, and -1 if A<B
# $t0 = COPY of A // and compare(mantissa)
# $t1 = sign of A
# $t2 = expo of A
# $t3 = mant of A
# $t4 = COPY of B (if exists)
# $t5 = sign of B
# $t6 = expo of B
# $t7 = mant of B
# $t8 = compare (sign)
# $t9 = compare (exponent)
CompareFloats:

  split_float($a0, $t0, $t1, $t2, $t3)  # split FP# A
  split_float($a1, $t4, $t5, $t6, $t7)  # split FP# B

  compare_reg($t8, $t1, $t5) # compare sign bit
    sub $t8, $zero, $t8  # Flip value just because 1 means (-) in FP:  -1 => 1, 1 => -1, 0 => 0

  compare_reg($t9, $t2, $t6) # compare expo
  compare_reg($t0, $t3, $t7) # compare mantissa

  #beqz $t8, compare_value # signs are the same, so do more complex comparissons
  move $v0, $t8 # store result

  jr $ra

# compare_value:

#   # since I dont have time, I'm going only to compare the mantissa or $t0
  
#   # Since both are assumed negative or postive, I can just check 1 reg
#   # if neg, the answer needs to be "flipped" bc -6 < -2, but abs(-6) > abs(-2)
#   bltz $t0, flip_value
#   move $t8, $t0
#   jr $ra

# flip_value:
#   xori $t8, $t8, 0x1
#   jr $ra

# Subroutine AddFloats
# Adds together two floating point values A and B.
# input: $a0 = Single precision float A
# $a1 = Single precision float B
# output: $v0 = Addition result A+B
# Side effects: None
# Notes: Returns the normalized FP result of A+B
# $t0 = COPY of A
# $t1 = sign of A
# $t2 = expo of A
# $t3 = mant of A
# $t4 = COPY of B (if exists)
# $t5 = sign of B
# $t6 = expo of B
# $t7 = mant of B
AddFloats:

  split_float($a0, $t0, $t1, $t2, $t3)  # split FP# A
  split_float($a1, $t4, $t5, $t6, $t7)  # split FP# B

  # check for same sign
  # bne		$t1, $t5, diff_sign	# if $t1 != $t5 then same_sign

  # Here the program would split into two
  # if the above break check is true, the signs are different
  # so a "diff_sign" method would be called

  # Here the program would split again
  # bne		$t2, $t6, diff_expo	# if $t2 != $t6 then diff_expo
  # if the exponents are "different" then they will be normalized

  # Here we know that bothe the sign and exponents are the same so we can finally add


  # To add FP# there are two cases...

  # CASE A: SAME SIGN
    # check if EXPONTENTS match
      # if not find OFFSET by subtracting smaller expo from larger
        # then shift HB.Mantissa of smaller number right by offset
    # Add together HB.Mantissa
    # Normalize & Round

  # CASE B: DIFFERENT SIGN
    # Check IF negative value magnitude is BIGGER then positive value magnitude
      # IF so result needs to be negative, if not then postive
      # subtract smaller magnitude from larger magntiude
    # Add (+/-) sign

  jr $ra

  # diff_sign:
  # diff_exponent:
    # Find offset
    # offset = sub $t9, $biggerEXPO, $smallerEXPO
    # shift HB.Mantissa by offset
    # slr $t8, $...

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

  # ADD exponents together (bias becomes "doubled"). Subtract bias ONCE
  # MULT HB.Mantissa of both A & B
  # Normalize & round if necessary

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

  move $t0, $a1   # move sign bit
  move $t1, $a1   # move mantiss part 1
  move $t2, $a2   # move mantiss part 2
  move $t3, $a3   # move expo

  sll $t0, $t0, 31 # shift over
  sll $t3, $t3, 22 # shift

  # Since I dont have time, I'm just going not use the result of this
  #find leading bit
  clz $t4, $t1
  addi $t4, $t4, 1 # incriment one

  # Here I would load 23 bits from the offset in $t4, round, etc.. , but for now
  # I'm just gonna "copy" $t4
  move $t5, $t1

  # OR together answer
  or $t9, $t9, $t0 # sign bit
  or $t9, $t9, $t3 # exponent
  or $t9, $t9, $t5 # mantissa

  # move answer to $v0 reg
  move $v0, $t9

  # in $a1 find the leading 1
    # clz $t0 $a1
    # leading 1 is "hidden bit" so skip it. 

  # Count 23 bits after that position to get the mantissa
    # implement rounding if wanted
      # check the 24th bit and round accordingly (1 > round up, 0 > nothing or round down)

  # OR together registers to get final result
    
  jr $ra