# Lab5.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01D, Rebecca

#CANT USE 1, 5, 6, 7, 8, 36

# =============

.data
  str_message_a: .asciiz "Input a hex number:\n"
  str_message_b: .ascii "The decimal value is:\n"
  str_prehex: .asciiz "0x"
  str_nl: .asciiz "\n"
  str_a: .asciiz "_0"
  str_b: .asciiz "_a"

# 1. Read	program	argument	string - DONE

# 2. Convert	the	program	argument	to	a	binary	integer in	$s0.
# 3. Convert	the	value in $s0	as	a 2SC	number	to	an	ASCII	decimal	number.
# 4. Print	the	correct	signed	ASCII	decimal	number before	exiting	cleanly.

# ASCII STRING  30 30 30 30 _ 30 46 30 30
# HEX   STRING   0  0  0  0 _  0  F  0  0

# IF HEX < 30 
# HEX - 30 = DEC
# 30 > 0
# ...
# 39 > 9

# IF HEX > 40
# HEX - 31 = dec
# 41 > 10
# ...
# 46 > 15

# 0000 0000 0000 0000 0000 0000 1111 0000 = 240
#    0    0    0    0    0    0    F    0

# DEFINE REGISTERS
# $s0 = ANSWER
# $s1 = 16 bits of input
# $s2 = 16 bits of input (2nd half)
# $s3 = value of 1/2
# $s4 = value of 2/2
# ---
# $t0 = COPY OF ADDY
# $t1 = ADDY + 2
# $t2 = ADDY + 4
# $t3 = DIVIDER
# $t4 = NUM
# $t5 = REM
# $t6 = CNT
# $t7 = ITER
# $t8 = ASCII TO HEX HELPER NUM (40)

.text
  li $s0, 0 #Value result
  li $t3, 256 # gives us 2 digits
  li $t6, 6
  li $t8, 0x40

  la  $t0, ($a1) #copy address to $t0
  lw  $t1, ($t0) #load addy into t1
  add $t1, $t1, 2
  add	$t2, $t1, 4		# $t2 = $t1 + 4

  lw $s1, ($t1) #load value into 7 from addy of 1
  lw $s2, ($t2) #load value into 7 from addy of 2

  jal print_message_a
  jal print_hex

	# loop_half_a:
	# 	bgt $t7, $t6, end_a # loop test (if i<=N) else exit
	# 	jal ascii_hex_a
	# 	addi $t7, $t7, 2 # i++
	# 	j loop_half_a # goto top
  # end_a:
  #   li $t7, 0
  
  # loop_half_b:
	# 	bgt $t7, $t6, end_b # loop test (if i<=N) else exit
	# 	jal ascii_hex_b
	# 	addi $t7, $t7, 2 # i++
	# 	j loop_half_b # goto top
  # end_b:
  #   li $t7, 0


  #more stuff
  jal print_message_b

  exit:
    li	$v0, 10  # exit code
		syscall

  # ascii_hex_a:
  #   div		$s1, $t3		# $t0 / $t1
  #   mflo	$t4					# $t2 = floor($t0 / $t1) 
  #   mfhi	$t5 				# $t3 = $t0 mod $t1

  #   ble		$t5, $t8, hex_num	  # if $t5 < $t8 then print_num
  #   bgt		$t5, $t8, hex_letter	# if $t5 > $t8 then print_char
    
  #   jr $ra

  # ascii_hex_b:
  #   div		$s2, $t3		# $t0 / $t1
  #   mflo	$t4					# $t2 = floor($t0 / $t1) 
  #   mfhi	$t5 				# $t3 = $t0 mod $t1

  #   ble		$t5, $t8, hex_num	  # if $t5 < $t8 then print_num
  #   bgt		$t5, $t8, hex_letter	# if $t5 > $t8 then print_char
    
  #   jr $ra

  # hex_num:
  #   li  $v0, 4
  #   la  $a0, str_a
  #   syscall
  #   jr $ra
    
  # hex_letter:
  # 	li  $v0, 4
  #   la  $a0, str_b
  #   syscall
  #   jr $ra

  print_message_a:
  	li  $v0, 4
    la  $a0, str_message_a
    syscall
    jr $ra

  print_message_b:
  	li  $v0, 4
    la  $a0, str_message_b
    syscall
    jr $ra

  print_hex:
    li  $v0, 4
    la  $a0, str_prehex
    syscall

    li  $v0, 4
		la  $a0, ($t1)
    syscall

    li  $v0, 4
    la  $a0, str_nl
    syscall

    jr $ra