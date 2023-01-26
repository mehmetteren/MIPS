	.text

	la	$a0, enterRegisterNumber
	li	$v0, 4
	syscall	
	li	$v0, 5
	syscall
	
	blt	$v0, 1, endProgramError
	bgt	$v0, 31, endProgramError	
	
	move	$a0, $v0
	jal registerCount
	move	$t6, $v0
	
# Example instructions for observing the registerCount result
	add $t0, $t0, $t0
	add $t0, $t0, $t0
	lw $t0, bits26to31
# ----------------------------------------------------------

	la	$a0, resultLabel
	li	$v0, 4
	syscall	

	move	$a0, $t6
	li	$v0, 1
	syscall
	
endProgram:
	li	$v0, 10
	syscall
	
endProgramError:
	la	$a0, errorText
	li	$v0, 4
	syscall
	li	$v0, 10
	syscall
	
	
	
	
registerCount:

	addi	$sp, $sp, -28
	sw	$s0, 24($sp)
	sw	$s1, 20($sp)
	sw	$s2, 16($sp)
	sw	$s3, 12($sp)
	sw	$s4, 8($sp)
	sw	$s5, 4($sp)
	sw	$ra, 0($sp) 
	
	move	$s0, $a0		# s0: register to count
	move	$s1, $zero		# s1: count

getPC:	
	li 	$s2, 0x00400000		# s2: current instruction address
	
regCountLoop:
	lw	$s3, 0($s2)		# s3: current instruction
	beq	$s3, $zero, endCountLoop
	lw	$s4, bits26to31
	and	$s5, $s3, $s4		# s5: opcode
	
	
	beq	$s5, $zero, rType
	beq	$s5, 0x0C000000, nextInstruction
	beq	$s5, 0x08000000, nextInstruction
	
iType:	
	lw	$s4, bits21to25
	and	$s5, $s3, $s4		# s5: rs
	srl	$s5, $s5, 21 
	
	bne	$s5, $s0, continue3
	jal	incrementCount
	
continue3:
	lw	$s4, bits16to20
	and	$s5, $s3, $s4		# s5: rt
	srl	$s5, $s5, 16 
	
	bne	$s5, $s0, nextInstruction
	jal	incrementCount
	j	nextInstruction
	
rType:
	lw	$s4, bits21to25
	and	$s5, $s3, $s4		# s5: rs
	srl	$s5, $s5, 21 
	
	bne	$s5, $s0, continue1
	jal	incrementCount
	
continue1:
	lw	$s4, bits16to20
	and	$s5, $s3, $s4		# s5: rt
	srl	$s5, $s5, 16 
	
	bne	$s5, $s0, continue2
	jal	incrementCount
	
continue2:
	lw	$s4, bits11to15
	and	$s5, $s3, $s4		# s5: rd
	srl	$s5, $s5, 11
	
	bne	$s5, $s0, nextInstruction
	jal	incrementCount

nextInstruction:
	addi	$s2, $s2, 4
	j	regCountLoop

endCountLoop:
	move	$v0, $s1
	lw	$ra, 0($sp)
	lw	$s5, 4($sp)
	lw	$s4, 8($sp)
	lw	$s3, 12($sp)
	lw	$s2, 16($sp)
	lw	$s1, 20($sp)
	lw	$s0, 24($sp)
	addi	$sp, $sp, 28
	jr	$ra
	

incrementCount:
	addi	$s1, $s1, 1
	jr	$ra
	
	
	
	
	.data
bits26to31:
	.word	0xFC000000	
bits21to25:
	.word	0x03E00000
bits16to20:
	.word	0x001F0000
bits11to15:
	.word	0x0000F800
	
enterRegisterNumber:
	.asciiz	"\nEnter the number of the register that you want to be counted: "
resultLabel:
	.asciiz	"\nRegister is used this many times: "
errorText:
	.asciiz	"\nInvalid register number"
