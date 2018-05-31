# Lab5.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01H, Carlos
# =============

# DEFINE REGISTERS
# -------------------------
# $s0 = ANSWER in decimal form
# $s1 = TEMP ANSWER before "OR" w/ $s0
# $s2 = SHIFT_COUNT, 28 at first, gets decrimented by 4 each loop
# $s6 = COPY or ANSWER ($s0)
# $s7 = VALUE of input
# ---
# $t0 = ADDRESS
# $t1 = SHIFTED addy
# $t2 = POINTER for ascii>dec loop
# $t3 = COUNT of digits
# $t4 = QUOTIENT (DEC)
# $t5 = REMAINDER
# $t6 = CNT of bits
# $t7 = ITERator
# $t8 = 10 (div helper)
# $t9 = ARRAY pointer

# --- PSEUDOCODE ---

# store string data
# Set default values

# copy address of input

# print message
# print hex

# loop (convert to decimal)
  # get each "letter"
    # if char or num
      # char -55, num - 48
      # add value to register (OR)
  # move pointer

# if # is neg. take 2CS
  # make positive + 1

# copy answer
# count digits
  # answer / 10
    # answer = quotient

# Get array address + # of digits

# loop (dec > ascii in array)
  # divide by 10, ANS /10
    # ANS = Quotient
    # REMAINDER + 48 = ascii value
    # store ASCII value in array + offset
    # offset--

# print number
  # if "-" flag is set print "-" char
  # print string from array poimter

# exit cleanly

# --- END OF PSEUDOCODE ---

.data
  str_nl: .asciiz "\n"
	str_prehex: .asciiz "0x"
  str_message_a: .asciiz "Input a hex number:\n"
  str_message_b: .ascii "The decimal value is:\n"
  array: .space 10

.text

  main:
    li $s0, 0 #Value result
    li $s1, 0
    li $s2, 28

    li $t3, 0
    la $t4, ($s0)
    li $t6, 8 # i < 8
    li $t7, 1 # int i
    li $t8, 10

    la    $t0, ($a1)  # copy address to $t0
    lw    $t1, ($t0)  # load addy into t1
    addi  $t1, $t1, 2 # shift away from "0x" prefix

    la $t2, ($t1)

    jal print_message_a # print "enter..."
    jal print_hex       # print "0x" prefix + input
    jal print_message_b # print "dec val is..."

  loop:
  	bgt  $t7, $t6, end_loop   # i < N
		jal  ascii_hex            # convert
		addi $t7, $t7, 1          # i++
    addi $t2, $t2, 1          # move pointer
    sub  $s2, $s2, 4          # move # to shift left
		j loop 

  end_loop:
    j end

  ascii_hex:
    lb    $s7, ($t2)          # load input
    ble	  $s7, 0x39, is_num	  # is 0-9
    bge   $s7, 0x41, is_char	# is A-F
    jr $ra

  #ASCII > DEC = ASCII - 48
  is_num:
    sub   $s7, $s7, 48		# -48
    sllv  $s1, $s7, $s2   # Shift left "$s2" times
    or    $s0, $s0, $s1   # OR w/ $s0
    jr $ra

  #ASCII > DEC = ASCII - 55
  is_char:
    sub   $s7, $s7, 55    # -55
    sllv  $s1, $s7, $s2   # shift left "$s2" times
    or    $s0, $s0, $s1   # OR w/ $s0
    jr $ra

  end:
    move  $s6, $s0                  # copy answer
    blt   $s6, $zero, do_complement	# is negative (x<0)
    j do_more

  do_complement:
    sub $s6, $zero, $s6   # make positive  0 - (-1) = +1

  do_more:
    move   $t4, $s6   # copy answer
    la     $t9, array # store array pointer

  # count # of digits for array shift
  loop_count:
    beqz  $t4, end_count
		div   $t4, $t8			# $t4 / 10 , Quotient
    mflo  $t4 				  # Remainder
    addi  $t3, $t3, 1   #count
		j loop_count

  end_count:
    move  $t4, $s6      # copy answer again
    add   $t9, $t9, $t3 # Array + offset (# of digits)
    j loop_store

  # store as a string
  loop_store:
    beqz $t4, end_store
    jal store_ascii
    j loop_store

  end_store:
    j print

  # Dec > ASCII then stores in an array
  store_ascii:
    div		$t4, $t8		# $t4 / 10
    mflo  $t4 				# Quotient
    mfhi  $t5					# Reaminder

    addi  $t5, $t5, 48	# +48 to convert to ascii
    sb    $t5, 0($t9)		# store number in array (backwards) 
    
    sub	$t9, $t9, 1     # move pointer --
    jr $ra

  print:
    blt   $s0, $zero, print_neg   # if negative, print "-"
    j print_num

  print_neg:
    li  $v0, 11   # print char
    la  $a0, 45   # load "-" ascii
    syscall

  print_num:
    la    $t9, array    # load array address
    addi  $t9, $t9, 1   # add one to addy
    li    $v0, 4
    la    $a0, ($t9)    # load start of array
    syscall
    j exit

  exit:
    li  $v0, 10  # exit cleanly
		syscall

  # print "input..."
  print_message_a:
  	li  $v0, 4
    la  $a0, str_message_a
    syscall
    jr $ra

  # print "the decimal is.."
  print_message_b:
  	li  $v0, 4
    la  $a0, str_message_b
    syscall
    jr $ra

  # print inputed hex number
  print_hex:
    li  $v0, 4
    la  $a0, str_prehex # prints "0x" prefix
    syscall

    li  $v0, 4
		la  $a0, ($t1)      # prints input
    syscall

    li  $v0, 4
    la  $a0, str_nl     # prints newline
    syscall

    jr $ra