# Strings
.data
	str_enternum: .asciiz "Enter a number: "
	str_feed: .asciiz "Feed\n"
	str_babe: .asciiz "Babe\n"
	str_feedbabe: .asciiz "FeedBabe\n"

.text
	li $s0, 0   # N (for now set to zero)
	li $s1, 1   # i in FOR loop
 	li $s2, 3   # MOD 3
	li $s3, 4   # MOD 4
	li $s4, 12  # MOD 12 == (MOD 3 && MOD 4)

	jal  out_num  # Ask user for input

	# Gets value from user 
	li $v0, 5
	syscall

	move $s0, $v0 # move value inputted to $s0 or N

	loop:
		bgt $s1, $s0, exit # loop test (if i<=N) else exit
		addi $s1, $s1, 1 # ++i
		j loop # restart loop

	exit:
			li	$v0, 10
			syscall

# Print "Enter a Number"
	out_num:
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