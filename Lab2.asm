# CS224
# Lab No. 2
# Section No. 3
# Mehmet Eren Balasar
# 22001954
# 13.10.2022	

	.text
	
#  main ================================================================================================
main:
	la	$a0, enterSize
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall
	move 	$t1, $v0		# t1: array size (number of elements)
	ble	$t1, $zero, main
	sw	$v0, arraySize
	
	mul	$t2, $t1, 4		# t2: array size (bytes)
	move	$a0, $t2		
	li	$v0, 9
	syscall
	move	$t0, $v0		# t0: address of the array
	sw	$t0, arrayAddress
	
	move	$a0, $t0
	move	$a1, $t1
	jal 	monitor
	move	$t0, $v0
	move	$t1, $v1
	
	la	$a0, minIs
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 1
	syscall

	la	$a0, blankSpace
	li	$v0, 4
	syscall
	
	la	$a0, maxIs
	li	$v0, 4
	syscall
	move	$a0, $t1
	li	$v0, 1
	syscall
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	
	lw	$t0, arrayAddress
	lw	$t1, arraySize
printLoop:
	lw	$a0, 0($t0)
	li	$v0, 1
	syscall
	la	$a0, blankSpace
	li	$v0, 4
	syscall
	addi	$t0, $t0, 4
	sub	$t1, $t1, 1
	bgt 	$t1, $zero, printLoop
end:
	li	$v0, 10
	syscall
	
	
#================================================================================================
# Monitor
# $a0: array pointer
# $a1: array size
#================================================================================================
monitor:
	move	$s7, $ra		# s7: return adress 
	move	$t5, $a0
	move	$t6, $a0
	move	$t1, $a1	
	
	
	li	$t3, 0			# t3: control
	la	$a0, enterItems
	li	$v0, 4
	syscall
	
inputLoop:
	li	$v0, 5
	syscall
	sw	$v0, 0($t5)
	
	addi	$t5, $t5, 4
	addi	$t3, $t3, 1	
	blt 	$t3, $t1, inputLoop
	
	
	move	$a0, $t6
	move	$a1, $t1
	jal	bubbleSort
	
minMax:
	lw	$v1, 0($t6)		# get the first element of the array
	sub	$t5, $t5, 4		# get the last element of the array
	lw	$v0, 0($t5)		# v1: last element of the array
	
	
monitorEnd:	
	jr	$s7
#================================================================================================

#================================================================================================
# Bubble Sort
# $a0: array pointer
# $a1: array size
#================================================================================================
bubbleSort:
	move	$s6, $a0		# s6: array pointer (permanent)
	move	$s1, $a1		# s1: array size
	li	$s2, 0			# s2: counter1
	li	$s3, 0			# s3: counter2
	
loop1:
	bge 	$s2, $s1, sortEnd
	move	$s0, $s6
	sub	$s5, $s1, $s2
	addi	$s2, $s2, 1
	li	$s3, 1

	
	loop2:
		beq	$s3, $s5, loop1
		lw	$t0, 0($s0)
		lw	$t1, 4($s0)
		blt	$t0, $t1, swap
	next:
		addi	$s0, $s0, 4
		addi	$s3, $s3, 1
		j	loop2
	
	swap:
		sw	$t0, 4($s0)
		sw	$t1, 0($s0)
		j	next

	
sortEnd:
	jr	$ra





#================================================================================================		
			
			
			
			
	
	.data
	
arraySize:
	.word		0
arrayAddress:
	.word		0
newLine:
	.asciiz 	"\n"
minIs:
	.asciiz 	"Minimum is: "
maxIs:
	.asciiz 	"Maximum is: "
blankSpace:
	.asciiz 	"  "
enterSize:
	.asciiz		"Enter array size (# of items): "
enterItems:
	.asciiz		"Enter items on by one: \n"
