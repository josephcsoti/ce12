.data

# Strings to be printed
str_feed: .asciiz "Feed\n"
str_babe: .asciiz "Babe\n"
str_feedbabe: .asciiz "FeedBabe\n"

#loop
.text 
main:
	li  $v0, 4
	la  $a0, str_feed
	syscall
	
#Print "Feed"

#Print "Babe"

#Print "FeedBabe