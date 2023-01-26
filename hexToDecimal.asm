# CS224
# Lab No. 2
# Section No. 3
# Mehmet Eren Balasar
# 22001954
# 12.10.2022
#================================================================================================
# main
#================================================================================================

	.text
begin:	
	jal	printMenu
	beq 	$v0, 1, conv
	beq 	$v0, 2, inv
	beq 	$v0, 3, end
	
conv:
	lw	$a0, stringAddress
	lw	$a1, hexLength
	jal	convertHexToDecimal
	move	$t5, $v0 
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	move	$a0, $t5
	li	$v0, 1
	syscall
	b	begin

inv:
	li	$v0, 5
	syscall	
	move	$a0, $v0
	li	$v0, 34
	syscall	
	
	jal	invertBytes
	move	$t0, $v0
	
	la	$a0, newLine
	li	$v0, 4
	syscall
	move	$a0, $t0
	li	$v0, 34
	syscall	
	b	begin	
	
end:
	li	$v0, 10
	syscall
	
#================================================================================================
#  Print menu
#================================================================================================
printMenu:	
	la	$a0, menu
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall				# v0: is the choice

	beq $v0, 1, op1
	beq $v0, 2, op2
	beq $v0, 3, quit
	
op1:
	la	$a0, enterHexLength
	li	$v0, 4
	syscall
	li	$v0, 5
	syscall		
	move	$t0, $v0		
	addi	$t0, $t0, 1		# add 1 to length because of null pointer
	sw	$v0, hexLength		# t0: hex length + 1
		
	move	$a0, $t0	
	li	$v0, 9
	syscall
	move	$s0, $v0		# s0: address of the hex string's beginning
	sw	$s0, stringAddress
	
	la	$a0, enterHex
	li	$v0, 4
	syscall
	
	move	$a0, $s0
	move	$a1, $t0
	li	$v0, 8
	syscall
	li	$v0, 1
	b 	printMenuDone
	
op2:
	la	$a0, enterDecimal
	li	$v0, 4
	syscall
	
	li	$v0, 2
	b 	printMenuDone
	
quit:
	li	$v0, 3
	
printMenuDone:
	jr	$ra

#================================================================================================
# Convert Hex To Decimal
# $a0: string pointer
# $a1: string size aka hex length
#================================================================================================
convertHexToDecimal:
	move	$s7, $ra
	move	$s0, $a0		# s0: string pointer
	move	$s1, $a1		# s1: string size
	sub	$s1, $s1, 1		# s1: biggest power of 16
	li	$s3, 0			# s3: the sum
	
mulLoop:
	lbu	$s2, 0($s0)
	sub	$s2, $s2, 48
	bgt 	$s2, 9, biggerThan9
	blt 	$s2, 0, convError
	b	continue
	
biggerThan9:
	sub	$s2, $s2, 39
	bgt 	$s2, 15, convError
	
continue:	
	li	$a0, 16
	move	$a1, $s1
	jal	power
	
	mul	$s2, $s2, $v0		# multiply the number with the proper multiple of 16
	add	$s3, $s3, $s2
	sub	$s1, $s1, 1
	addi	$s0, $s0, 1
	bge	$s1, $zero, mulLoop
	b	convEnd
		
				
convError:
	la	$a0, error0
	li	$v0, 4
	syscall
	b 	end
convEnd:
	move	$v0, $s3 
	jr	$s7
#================================================================================================
	
#================================================================================================
# Inverts bytes of a hexadecimal
# $a0: hexadecimal number
#================================================================================================	
invertBytes:
	move	$t0, $a0		# t0: hex number
	sw	$t0, invertVar
	la	$t0, invertVar		# t0: hex number's address
	li	$t1, 4			# t1: counter

	la	$s0, 0			# s0: inverted hex
	
invLoop:
	lbu	$t2, 0($t0)		# t2: 8-bit segment
	
	sll	$s0, $s0, 8
	add	$s0, $s0, $t2
	
	addi	$t0, $t0, 1
	sub	$t1, $t1, 1
	bgt 	$t1, $zero, invLoop
	
invEnd:
	move	$v0, $s0
	jr	$ra	
	

#================================================================================================
# Calculates a power of a number
# $a0: number
# $a1: power
#================================================================================================
power:
	move	$t0, $a0		# t0: number
	move	$t1, $a1		# t1: power
	li	$t2, 1
	beq	$t1, $zero, powerResult

	
powerLoop:
	mul	$t2, $t2, $t0
	sub	$t1, $t1, 1
	bne	$t1, $zero, powerLoop
	
powerResult:
	move	$v0, $t2
	jr	$ra

#================================================================================================


	.data

hexLength:
	.word		0
stringAddress:
	.word		0
invertVar:
	.word		0
inputString:
	.space		32
newLine:
	.asciiz 	"\n"
menu:
	.asciiz		"\nEnter 1 to convert hex to decimal \nEnter 2 to invert bytes \nEnter 3 to quit\n"	
enterHexLength:
	.asciiz		"Enter the length of your hexadecimal number: "
enterHex:
	.asciiz		"Enter the hexadecimal number: "
enterDecimal:
	.asciiz		"Enter a decimal number: "
example:
	.asciiz 	"0123"
error0:
	.asciiz		"input error\n"