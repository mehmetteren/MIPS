	.text
	
#main
#===========================================================================
main:
	la	$a0, enterDividend
	li	$v0, 4
	syscall	
	li	$v0, 5
	syscall
	move	$t0, $v0
	ble	$t0, $zero, endProgram
	
	la	$a0, enterDivisor
	li	$v0, 4
	syscall	
	li	$v0, 5
	syscall
	move	$t1, $v0
	ble	$t1, $zero, endProgram
	
	move	$a0, $t0
	move	$a1, $t1
	jal	recursiveDivision
	move	$t0, $v0
	
	la	$a0, divResult
	li	$v0, 4
	syscall
	
	move	$a0, $t0
	li	$v0, 1
	syscall
	
	j	main

endProgram:
	la	$a0, invalidInput
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
	
#===========================================================================
#recursiveDivision
# a0: dividend
# a1: divisor
# returns a0/a1
#===========================================================================
recursiveDivision:
	addi 	$sp, $sp, -8
	sw	$a0, 4($sp)
	sw	$ra, 0($sp)


	li	$v0, 0
	bgt	$a1, $a0, divEnd

	sub	$a0, $a0, $a1
	jal	recursiveDivision
	
	addi	$v0, $v0, 1
	
divEnd:
	lw	$ra, 0($sp)
	lw	$a0, 4($sp)
	addi	$sp, $sp, 8
	jr	$ra
	
	
	
	
	
	
	
	
	.data
enterDividend:
	.asciiz	"\n\nEnter dividend: "
enterDivisor:
	.asciiz	"\nEnter divisor: "
divResult:
	.asciiz	"\nDivision result: "
invalidInput:
	.asciiz	"\nInvalid operand, quitting..."