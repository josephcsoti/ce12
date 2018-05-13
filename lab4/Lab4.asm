# Lab4.asm
# Joseph Csoti, jcsoti@ucsc.edu
# CMPE 12 SPRING 2018
# Section 01D, Rebecca


# Strings to be printed
.data
	str_enternum:  .asciiz "Please input a number:"
	str_feed:      .asciiz "Feed\n"
	str_babe:      .asciiz "Babe\n"
	str_feedbabe:  .asciiz "FeedBabe\n"
	str_nl:        .asciiz "\n"

.text
	li $s0, 0   # N (for now set to zero)
	li $s1, 1   # i in FOR loop
 	li $s2, 3   # MOD 3
	li $s3, 4   # MOD 4
	li $s4, 12  # MOD 12 == (MOD 3 && MOD 4)

	jal  out_enternum  # Ask user for input

	# Gets value from user 
	li $v0, 5
	syscall

	move $s0, $v0 # move value inputted to $s0 or N

 # For Loop, for (i=1; i<=N; i++)
	loop:
		bgt $s1, $s0, exit # loop test (if i<=N) else exit
		jal mod_feedbabe
		addi $s1, $s1, 1 # i++
		j loop # goto top

	exit:
			li	$v0, 10  # exit code
			syscall

	# MOD functions

	# MOD 3 && MOD 4 == (MOD 12)
	mod_feedbabe:
		div		$s1, $s4		          # i / 12
		mfhi	$t0					          # $t0 = i % 12
		beq		$t0, 0, out_feedbabe  # if $t0 == 0 then out_feedbabe
		bne		$t0, 0, mod_feed      # if $t0 != 0 then mod_feed 
		jr $ra
	
	# MOD 3
	mod_feed:
		div		$s1, $s2		      # i / 3
		mfhi	$t1					      # $t0 = i % 3
		beq		$t1, 0, out_feed  # if $t1 == 0 then out_feed
		bne		$t1, 0, mod_babe  # if $t1 != 0 then mod_feed 
		jr $ra

	# MOD 4
	mod_babe:
		div		$s1, $s3		      # i / 4
		mfhi	$t2					      # $t0 = i % 4
		beq		$t2, 0, out_babe  # if $t2 == 0 then out_babe
		bne		$t2, 0, out_num   # if $t2 != 0 then out_num
		jr $ra

	# Print "Enter a Number"
	out_enternum:
		li  $v0, 4
		la  $a0, str_enternum
		syscall
		jr $ra

	# Print "Feed"
	out_feed:
		li  $v0, 4
		la  $a0, str_feed
		syscall
		jr $ra

	# Print "Babe"
	out_babe:
		li  $v0, 4
		la  $a0, str_babe
		syscall
		jr $ra
			
	# Print "FeedBabe"
	out_feedbabe:
		li  $v0, 4
		la  $a0, str_feedbabe
		syscall
		jr $ra

	# Print '# + \n'
	out_num:
		li  $v0, 1
		add $a0, $s1, $zero
		syscall

		# Print newline
		li  $v0, 4
		la  $a0, str_nl
		syscall

		jr $ra