
	.text
	
# Get array size from user
	li 	$v0, 5
	syscall
	sw 	$v0, arraySize
	
# Set arguments to populate the array
	la 	$a0, array
	lw 	$a1, arraySize

# Populate array
	la 	$a0, array
	lw 	$a1, arraySize

	jal 	populateArray
	jal	printArray
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
# Swap the elements of the array
	la 	$a0, array
	lw 	$a1, arraySize

	jal 	swapArray
	
# Print array in subprogram printArray
	la 	$a0, array
	lw 	$a1, arraySize

	jal	printArray
	
# stop
	li	$v0, 10
	syscall
	
	
#===============================================================
populateArray:
	move	$t0, $a0	# $t0: array pointer
	move	$t1, $a1	# $t1: array size
	li	$t4, 4		# $t4: control variable
	li	$t3, 1
	j	test
again:	
	sw	$t3, 0($t0)
	addi	$t4, $t4, 4
	addi	$t3, $t3, 1
	addi	$t0, $t0, 4
	
test:	
	ble	$t4, $t1, again
	jr	$ra		# Go back
#===============================================================
#===============================================================
swapArray:
	move	$t0, $a0	# $t0: array pointer
	move	$t1, $a1	# $t1: array size (bytes)
	add 	$t2, $t0, $t1 	# $t2: pointer to last item of the array
	addi	$t2, $t2, -4 

	j	test2
again2:	
	lw	$t3, 0($t0)	# $t3: item from beginning
	lw	$t4, 0($t2)	# $t4: item from end
	sw	$t3, 0($t2)	
	sw	$t4, 0($t0)
	addi	$t0, $t0, 4
	addi	$t2, $t2, -4
	
test2:	
	ble	$t0, $t2, again2
	jr	$ra		# Go back
#===============================================================
#===============================================================
printArray:
	move	$t0, $a0	# $t0: array pointer
	move	$t1, $a1	# $t1: array size
	li	$t3, 4
	j	test3
again3:	
# Print array element pointed by $t0.
	lw	$a0, 0($t0)
	li	$v0, 1
	syscall
	la	$a0, blankSpace
	li	$v0, 4
	syscall
	addi	$t3, $t3, 4
	addi	$t0, $t0, 4
	
test3:	
	ble 	$t3, $t1, again3
	jr	$ra		# Go back
#===============================================================



	.data
blankSpace:
 	.asciiz 	" "
 newLine:
 	.asciiz 	"\n"
arraySize:	
	.word		0
array:	.space 		80
