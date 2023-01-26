	.text
	
main:
#===========================================================================
	la	$a0, enterSize
	li	$v0, 4
	syscall	
	li	$v0, 5
	syscall
	
	move	$a0, $v0
	jal	createLinkedList
	move	$t1, $v0
	sw	$t1, list1
	
	
	la	$a0, list1Text
	li	$v0, 4
	syscall	
	lw	$a0, list1
	jal 	printLinkedList
	
	
	la	$a0, reversedLabel
	li	$v0, 4
	syscall	
	lw	$a1, list1
	jal 	displayReverseOrderRecursive
	
	li	$v0, 10
	syscall
	
	
# a1: linked list pointer	
displayReverseOrderRecursive:
	addi	$sp, $sp, -12
	sw	$a1, 8($sp)
	sw	$a2, 4($sp)
	sw	$ra, 0($sp)
	
	beq	$a1, $zero, return
	lw	$a2, 4($a1)
	lw	$a1, 0($a1)
	
	jal 	displayReverseOrderRecursive

	li	$v0, 1
	move	$a0, $a2
	syscall
	la	$a0, space
	li	$v0, 4
	syscall	
return:
	lw	$ra, 0($sp)
	lw	$a2, 4($sp)
	lw	$a1, 8($sp)
	addi	$sp, $sp, 12
	jr	$ra
#=========================================================	
	
	
	
	
#=========================================================
createLinkedList:
# $a0: No. of nodes to be created ($a0 >= 1)
# $a1: multiplier
# $v0: returns list head
# Node 1 contains 4 in the data field, node i contains the value 4*i in the data field.
# By 4*i inserting a data value like this
# when we print linked list we can differentiate the node content from the node sequence no (1, 2, ...).
	addi	$sp, $sp, -24
	sw	$s0, 20($sp)
	sw	$s1, 16($sp)
	sw	$s2, 12($sp)
	sw	$s3, 8($sp)
	sw	$s4, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram
	
	move	$s0, $a0	# $s0: no. of nodes to be created.
	ble	$s0, $zero, empty
	li	$s1, 1		# $s1: Node counter
# Create the first node: header.
# Each node is 8 bytes: link field then data field.
	li	$a0, 8
	li	$v0, 9
	syscall
# OK now we have the list head. Save list head pointer 
	move	$s2, $v0	# $s2 points to the first and last node of the linked list.
	move	$s3, $v0	# $s3 now points to the list head.
	
	la	$a0, enterItems
	li	$v0, 4
	syscall

	li	$v0, 5
	syscall

	sw	$v0, 4($s2)	# Store the data value.
	
addNode:
# Are we done?
# No. of nodes created compared with the number of nodes to be created.
	beq	$s1, $s0, allDone
	addi	$s1, $s1, 1	# Increment node counter.
	li	$a0, 8 		# Remember: Node size is 8 bytes.
	li	$v0, 9
	syscall
# Connect the this node to the lst node pointed by $s2.
	sw	$v0, 0($s2)
# Now make $s2 pointing to the newly created node.
	move	$s2, $v0	# $s2 now points to the new node.

	li	$v0, 5
	syscall	
# sll: So that node 1 data value will be 4, node i data value will be 4*i
	sw	$v0, 4($s2)	# Store the data value.
	j	addNode
allDone:
# Make sure that the link field of the last node cotains 0.
# The last node is pointed by $s2.
	sw	$zero, 0($s2)
	move	$v0, $s3	# Now $v0 points to the list head ($s3).
	
end:
# Restore the register values
	lw	$ra, 0($sp)
	lw	$s4, 4($sp)
	lw	$s3, 8($sp)
	lw	$s2, 12($sp)
	lw	$s1, 16($sp)
	lw	$s0, 20($sp)
	addi	$sp, $sp, 24
	
	jr	$ra
	
empty:
	li	$v0, 0
	j	end
#=========================================================
printLinkedList:
# Print linked list nodes in the following format
# --------------------------------------
# Node No: xxxx (dec)
# Address of Current Node: xxxx (hex)
# Address of Next Node: xxxx (hex)
# Data Value of Current Node: xxx (dec)
# --------------------------------------

# Save $s registers used
	addi	$sp, $sp, -20
	sw	$s0, 16($sp)
	sw	$s1, 12($sp)
	sw	$s2, 8($sp)
	sw	$s3, 4($sp)
	sw	$ra, 0($sp) 	# Save $ra just in case we may want to call a subprogram

# $a0: points to the linked list.
# $s0: Address of current
# s1: Address of next
# $2: Data of current
# $s3: Node counter: 1, 2, ...
	move $s0, $a0	# $s0: points to the current node.
	li   $s3, 0
printNextNode:
	beq	$s0, $zero, printedAll
				# $s0: Address of current node
	lw	$s1, 0($s0)	# $s1: Address of  next node
	lw	$s2, 4($s0)	# $s2: Data of current node
	addi	$s3, $s3, 1
# $s0: address of current node: print in hex.
# $s1: address of next node: print in hex.
# $s2: data field value of current node: print in decimal.
	la	$a0, line
	li	$v0, 4
	syscall		# Print line seperator
	
	la	$a0, nodeNumberLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s3	# $s3: Node number (position) of current node
	li	$v0, 1
	syscall
	
	la	$a0, addressOfCurrentNodeLabel
	li	$v0, 4
	syscall
	
	move	$a0, $s0	# $s0: Address of current node
	li	$v0, 34
	syscall

	la	$a0, addressOfNextNodeLabel
	li	$v0, 4
	syscall
	move	$a0, $s1	# $s0: Address of next node
	li	$v0, 34
	syscall	
	
	la	$a0, dataValueOfCurrentNode
	li	$v0, 4
	syscall
		
	move	$a0, $s2	# $s2: Data of current node
	li	$v0, 1		
	syscall	

# Now consider next node.
	move	$s0, $s1	# Consider next node.
	j	printNextNode
printedAll:
# Restore the register values
	
	lw	$ra, 0($sp)
	lw	$s3, 4($sp)
	lw	$s2, 8($sp)
	lw	$s1, 12($sp)
	lw	$s0, 16($sp)
	addi	$sp, $sp, 20
	jr	$ra
#=========================================================




	
	
	.data
list1:
	.word	0
space:	
	.asciiz " "
list1Text:	
	.asciiz "\n\n*****\Initial list: "
reversedLabel:	
	.asciiz "\n\n*****\nPrinted in reverse order: "
enterItems:	
	.asciiz "Enter items one by one: \n"
enterSize:	
	.asciiz "\nEnter a size: "
	
line:	
	.asciiz "\n --------------------------------------"

nodeNumberLabel:
	.asciiz	"\n Node No.: "
	
addressOfCurrentNodeLabel:
	.asciiz	"\n Address of Current Node: "
	
addressOfNextNodeLabel:
	.asciiz	"\n Address of Next Node: "
	
dataValueOfCurrentNode:
	.asciiz	"\n Data Value of Current Node: "	

	