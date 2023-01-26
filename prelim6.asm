# Course No.: CS224
# Lab 6
# Section 3
# Mehmet Eren Balasar
# 22001954

# matrix calculator
# User interface for matrix summation

# Prompt user for matrix size in terms of its dimensions
li $v0, 4           
la $a0, input_msg1   
syscall

li $v0, 5           # system call code for read_int
syscall

move $s0, $v0       # save matrix size in $s0 for future reference
sw $s0, matrixSize

# Allocate memory for matrix using syscall code 9

li $v0, 9
mul $s2, $s0, $s0          
move $a0, $s2         # number of elements in matrix
sw $s2, elementCount

li $a1, 2           
mul $a0, $a1, $a0   
syscall

# Store starting address of matrix in $s1
move $s1, $v0
sw $s1, matrixAddress

li $v0, 4          
la $a0, input_msg_num   
syscall

move $t0, $s2	#t0 is num of elements
move $t3, $s1	# t3 is address

inputLoop:
beq $t0, $zero, endInputLoop

#li $v0, 5           # system call code for read_int
#syscall

sh $t0, 0($t3)
addi $t3, $t3, 2
addi $t0, $t0, -1

j inputLoop

endInputLoop:

jal columnMajor
move $a0, $v0
li $v0, 1
syscall

j endProgram



mainMenu:
li $v0, 4           
la $a0, menu  
syscall

li $v0, 5           # system call code for read_int
syscall
beq $v0, 1, menuAccess
beq $v0, 2, menuRow
beq $v0, 3, menuColumn
b endProgram

menuAccess:
li $v0, 4           
la $a0, menuAccessMsg1 
syscall
li $v0, 5           # system call code for read_int
syscall
move $t0, $v0

li $v0, 4           
la $a0, menuAccessMsg2
syscall
li $v0, 5           # system call code for read_int
syscall

move $a1, $v0
move $a0, $t0

jal access
move $a0, $v0
li $v0, 1
syscall

j mainMenu


menuRow:
jal rowMajor
move $a0, $v0
li $v0, 1
syscall

j mainMenu

menuColumn:
jal columnMajor
move $a0, $v0
li $v0, 1
syscall

j mainMenu

endProgram:
	li	$v0, 10
	syscall

#===========================================================================

rowMajor:
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp) 

lw $s0, matrixAddress
lw $s1, elementCount
add $t1, $zero, $zero		#t1: sum

rowMajorLoop:
beq $s1, $zero, rowMajorLoopEnd

lh $t0, 0($s0)		#t0: an element
add $t1, $t1, $t0

addi $s0, $s0, 2
addi $s1, $s1, -1

j rowMajorLoop

rowMajorLoopEnd:
move $v0, $t1

	lw	$ra, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	
jr	$ra
#===========================================================================

#===========================================================================

columnMajor:
	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp) 

lw $s0, matrixAddress
lw $s1, matrixSize
move $t1, $zero		#t1: loop1 controller
move $t2, $zero		#t2: loop2 controller
add $t5, $zero, $zero		#t1: sum

columnMajorLoop:
bge $t1, $s1, columnMajorLoopEnd
move $t3, $s0		#t3: address to use in innerloop
move $t2, $zero
	innerLoop:
	bge $t2, $s1, innerLoopEnd
	
	lh $t0, 0($t3)		#t0: an element
	add $t5, $t5, $t0
	mul $t4, $s1, 2		
	add $t3, $t3, $t4		# t3 + t4 (column size * 2)
	
	addi $t2, $t2, 1
	j innerLoop
	
innerLoopEnd:
addi $s0, $s0, 2
addi $t1, $t1, 1

j columnMajorLoop

columnMajorLoopEnd:
move $v0, $t5

	lw	$ra, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	
jr	$ra
#===========================================================================



### access an element of the matrix (i,j)
# a0: i
# a1: j
# (i - 1) x N x 2 + (j - 1) x 2
access:

	addi	$sp, $sp, -12
	sw	$s0, 8($sp)
	sw	$s1, 4($sp)
	sw	$ra, 0($sp) 

lw $s0, matrixAddress
lw $s1, matrixSize
move $t0, $a0
move $t1, $a1

addi $t0, $t0, -1
mul $t0, $t0, $s1
mul $t0, $t0, 2

addi $t1, $t1, -1 
mul $t1, $t1, 2

add $t0, $t0, $t1
add $t0, $s0, $t0

lh $v0, 0($t0)

	lw	$ra, 0($sp)
	lw	$s1, 4($sp)
	lw	$s0, 8($sp)
	addi	$sp, $sp, 12
	
jr	$ra
#===========================================================================

.data
matrixAddress: .word 0
elementCount: .word 0
matrixSize: .word 0
input_msg1: .asciiz "Enter matrix size (e.g. enter 3 for 3x3): "
input_msg_num: .asciiz "creating matrix\n"
menuAccessMsg1: .asciiz "Enter i: "
menuAccessMsg2: .asciiz "Enter j: "
menu: .asciiz "\nEnter choice (0 to exit): \n1.Display an element by entering (i,j)\n2.Calculate row-major sum\n3.Calculate column-major sum\n"
