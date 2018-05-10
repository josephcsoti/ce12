# Strings
.data
	str_feed: .asciiz "Feed\n"
	str_babe: .asciiz "Babe\n"
	str_feedbabe: .asciiz "FeedBabe\n"

#
main:
	j out_feed
	j out_babe
	j out_feedbabe
	syscall
	
# Print "Feed"
.text
	out_feed:
		li  $v0, 4
		la  $a0, str_feed
		syscall
		
# Print "Babe"
.text
	out_babe:
		li  $v0, 4
		la  $a0, str_babe
		syscall
		
# Print "FeedBabe"
.text
	out_feedbabe:
		li  $v0, 4
		la  $a0, str_feedbabe
		syscall