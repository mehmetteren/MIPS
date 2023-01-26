
# Get values from the user
	la	$a0, message0
	li	$v0, 4
	syscall
	
	la	$a0, message1
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	sw 	$v0, firstOperand
	
	la	$a0, message2
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	sw 	$v0, secondOperand

	la	$a0, message3
	li	$v0, 4
	syscall
	li 	$v0, 5
	syscall
	sw 	$v0, thirdOperand
	
	la	$a0, message4
	li	$v0, 4
	syscall

	lw	$s0, firstOperand	# s0: a
	lw	$s1, secondOperand	# s1: b
	lw	$s2, thirdOperand	# s2: c
	
	mul	$t1, $s0, 2		# t1: 2a
	mul	$t0, $t1, $s1		# t0: 2a*b
	
	
# Set arguments for divide
	
	div	$t0, $s2
	mflo	$t0			# t0: (2a*b)/c

	sub 	$t3, $s0, $s2		# t3: a-c
	
	mul	$t4, $t0, $t3		# t4 is the result
	
	
	move	$a0, $t4
	li	$v0, 1
	syscall
	la	$a0, blankSpace
	li	$v0, 4
	syscall
	
# stop
	li	$v0, 10
	syscall


#===============================================================
divide:				# $a0 / $a1 = $v0, $a0 % $a1 = $v1
	move	$t0, $a0	# $t0 is the dividend
	move 	$t1, $a1	# $t1 is the divisor
	move	$t2, $zero	# $t2 is the quotient
	move	$t3, $t0	# $t3 is the remainder
	
test:
	sub	$t3, $t3, $t1
	bge	$t3, $zero, left
	j	right
	
left:
	addi	$t2, $t2, 1
	j	test
	
right:
	add 	$t3, $t3, $t1
	

end:

	move 	$v0, $t2
	move 	$v1, $t3
	jr	$ra
#===============================================================


	.data
firstOperand:	.word	0
secondOperand:	.word	0
thirdOperand:	.word	0
			
blankSpace:
	.asciiz		" "
message0:
	.asciiz		"Please enter values \n"
message1:
	.asciiz		"a: "
message2:
	.asciiz 	"b: "
message3:
	.asciiz 	"c: "
message4:
	.asciiz 	"Equation to compute: x = ((2a * b) / c) * (a - c) -> x =  "





