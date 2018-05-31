# Lab5.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01D, Rebecca

#CANT USE 1, 5, 6, 7, 8, 36

# =============

.data
  str_nl: .asciiz "\n"
	str_prehex: .asciiz "0x"
  str_message_a: .asciiz "Input a hex number:\n"
  str_message_b: .ascii "The decimal value is:\n"
  array: .space 10

# DEFINE REGISTERS
# $s0 = ANSWER
# $s1 = TEMP_answer
# $s2 = SHIFT_COUNT
# $s3 = ????
# $s4 = ARRAY POINTER (TOP)
# $s5 = CUURENT ARRAY POINTER
# $s6 = store if pos/neg
# ---
# $t0 = COPY OF ADDY
# $t1 = ADDY + 2
# $t2 = CURSOR

# $t6 = CNT
# $t7 = ITER

.text

  main:
    li $s0, 0 #Value result
    li $s1, 0
    li $s2, 28
    #la $s4, array

    li $t3, 0
    la $t4, ($s0)
    li $t6, 8 # i < 8
    li $t7, 1 # int i
    li $t8, 10


    la  $t0, ($a1) #copy address to $t0
    lw  $t1, ($t0) #load addy into t1
    addi $t1, $t1, 2 #shift away from "0x" prefix

    la $t2, ($t1)
    #add $t2, $t1, $zero

    jal print_message_a
    jal print_hex
    jal print_message_b

    #sb ++
    #lb --

  loop:
  	bgt $t7, $t6, end_loop
		jal ascii_hex
		addi $t7, $t7, 1 # i++
    addi $t2, $t2, 1 #move pointer
    sub $s2, $s2, 4 # move # to shift
		j loop # goto top
  end_loop:
    j end

  ascii_hex:
    lb		$s7, ($t2)
    ble		$s7, 0x39, is_num	  # if $t5 < $t8 then print_num
    bge		$s7, 0x41, is_char	# if $t5 > $t8 then print_char
    jr $ra

  #ASCII > DEC = ASCII - 48
  is_num:
    sub		$s7, $s7, 48		# $s7 = $s7 - 48
    sllv $s1, $s7, $s2 
    or $s0, $s0, $s1
    jr $ra

  #ASCII > DEC = ASCII - 55
  is_char:
    sub		$s7, $s7, 55		# $s7 = $s7 - 55
    sllv $s1, $s7, $s2 
    or $s0, $s0, $s1
    jr $ra
  
  end:
  # $t3 = COUNT
  # $t4 = QUOTIENT
  # $t5 = REM

  # $t9
  move 	$t4, $s0 # now hold answer
  la $t9, array #pointer

  loop_count:
    beqz $t4, end_count
		div		$t4, $t8			# $t4 / 10
    mflo	$t4 				# $t2 = floor($t4 / 10) 
    addi $t3, $t3, 1 #count
		j loop_count # goto top
  end_count:
    move 	$t4, $s0 # now hold answer
    add $t9, $t9, $t3 # how much to offest
    j loop_store

  loop_store:
    beqz $t4, end_store
    jal store_ascii
    j loop_store
  end_store:
    j print

  store_ascii:
    div		$t4, $t8			# $t4 / 10
    mflo	$t4 				# $t2 = floor($t4 / 10) 
    mfhi	$t5					# $t3 = $t4 mod 10

    addi		$t5, $t5, 48		# $t5 = $t1 + 48
    sb		$t5, 0($t9)		# 
    
    sub	$t9, $t9, 1
    jr $ra

  print:
    la $t9, array
    addi $t9, $t9, 1
    li  $v0, 4
    la  $a0, ($t9)
    syscall
    j exit

  exit:
    li	$v0, 10  # exit code
		syscall

  # 11 chars long max, 10 nums & - sign

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