
	.text
	
	jal	printMenu

	
end:
	li	$v0, 10
	syscall
	
#================================================================================================
#  Print menu
#================================================================================================
printMenu:	
	move	$s7, $ra		# save return address to s7
	
	la	$a0, enterSize
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move 	$t1, $v0		# t1: array size
	sw	$v0, arraySize
	
	la	$t0, array		# t0: array pointer
	li	$t2, 0			# t2: control
	
	la	$a0, enterItems
	li	$v0, 4
	syscall
inputLoop:
	li	$v0, 5
	syscall
	sw	$v0, 0($t0)
	
	addi	$t0, $t0, 4
	addi	$t2, $t2, 1	
	blt 	$t2, $t1, inputLoop
	
choice:
	la	$a0, menu
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall				# v0: is the choice

	beq $v0, 1, op1
	beq $v0, 2, op2
	beq $v0, 3, op3
	beq $v0, 4, quit
quit:
	jr	$s7
	
op1:
	
	la	$a0, enterInput
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall	
	
	move	$a2, $v0	# a2: input number
	la	$a0, array
	lw	$a1, arraySize
	jal summation
	move 	$s0, $v0	# s0: result
	
	la	$a0, op1Result
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	li	$v0, 1
	syscall
	
	b choice
	
op2:
	la	$a0, array
	lw	$a1, arraySize
	
	jal evenOdd
	
	move 	$s0, $v0	# s0: result 1
	move 	$s1, $v1	# s1: result 2
	
	la	$a0, op2Result
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	li	$v0, 1
	syscall
	
	la	$a0, blankSpace
	li	$v0, 4
	syscall
	
	move	$a0, $s1
	li	$v0, 1
	syscall
	
	b choice
	
op3:
	
	la	$a0, enterInput
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall	
	
	move	$a2, $v0	# a2: input number
	la	$a0, array
	lw	$a1, arraySize
	jal occurence
	move 	$s0, $v0	# s0: result
	
	la	$a0, op3Result
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	li	$v0, 1
	syscall
	
	b choice

#================================================================================================
# Find summation of numbers stored in the array which is greater than an input number.
#	arraysize is in bytes
#================================================================================================
summation:
	move	$t0, $a0	# t0: array pointer
	move	$t1, $a1	# t1: array size
	move	$t2, $a2	# t2: input number
	li	$t4, 0		# t4: control
	
	li	$v0, 0		# initialize sum
	
loop1:	
	lw	$t3, 0($t0)	# t3: current element
	ble	$t3, $t2, skip
	add	$v0, $v0, $t3
	
skip:
	addi	$t0, $t0, 4
	addi	$t4, $t4, 1	
	blt 	$t4, $t1, loop1
	
	
	jr	$ra 
#================================================================================================
	
#================================================================================================	
# Find summation of even and odd numbers and display them.
#================================================================================================	
evenOdd:
	move	$t0, $a0	# t0: array pointer
	move	$t1, $a1	# t1: array size
	li	$t4, 0		# t4: control
	li	$t5, 2		# t5: 2
	
	li	$v0, 0		# v0: initialize even sum
	li	$v1, 0		# v1: initialize odd sum
	
loop2:
	lw	$t3, 0($t0)	# t3: current element
	div	$t3, $t5	# divide by 2
	mfhi	$t6
	beq 	$t6, $zero, even

odd:
	add	$v1, $v1, $t3
	b 	test
even:
	add	$v0, $v0, $t3

test:
	addi	$t0, $t0, 4
	addi	$t4, $t4, 1	
	blt 	$t4, $t1, loop2
	
	jr	$ra 
#================================================================================================

#================================================================================================	
# Display the number of occurrences of the array elements divisible by a certain input number.
#================================================================================================	
occurence:
	move	$t0, $a0	# t0: array pointer
	move	$t1, $a1	# t1: array size
	move	$t2, $a2	# t2: input number
	li	$t4, 0		# t4: control
	
	li	$v0, 0		# v0: number of occurences
	
loop3:
	lw	$t3, 0($t0)	# t3: current element
	div	$t3, $t2	# divide by input
	mfhi	$t6
	bne  	$t6, $zero, test2

divisible:
	addi	$v0, $v0, 1

test2:
	addi	$t0, $t0, 4
	addi	$t4, $t4, 1	
	blt 	$t4, $t1, loop3
	
	jr	$ra 
#================================================================================================
	
	
	.data
array:	.space		100
	
blankSpace:
	.asciiz 	" "
enterSize:
	.asciiz		"Enter array size (# of items): "
enterItems:
	.asciiz		"Enter items on by one: \n"
menu:
	.asciiz		"\nEnter 1 for summation \nEnter 2 for even odd summation \nEnter 3 for #of divisibles \nEnter 4 to quit \n"
enterInput:
	.asciiz		"Enter input num: "
op1Result:
	.asciiz		"Summation of numbers greater than input number: "
op2Result:
	.asciiz		"Summation of even and odd numbers (first even, second odd):  "
op3Result:
	.asciiz		"Number of elements divisible by input number: "
	
	
arraySize:
	.word		0


	





