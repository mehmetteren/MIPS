	.text
# A simple program that shows the use of lh (load half word) and
# sh (store half word) instructions.
	la	$t0, array
	li	$t1, 16
next:
	lh	$t2, 0($t0)
	addi	$t2, $t2, 1
	sh	$t2, 0($t0)
	addi	$t0, $t0, 2
	addi	$t1, $t1, -1
	bne	$t1, $zero, next
	li	$v0, 10
	syscall
	
	.data

array:	.half	0, 0, 0, 0, 
		0, 0, 0, 0, 
		0, 0, 0, 0, 
		0, 0, 0, 0, 
	