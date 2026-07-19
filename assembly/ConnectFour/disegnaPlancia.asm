.globl disegnaPlancia
.data

.text

disegnaPlancia:
la $t0 plancia
li $t1 0
li $t4 9

li $v0 11
li $a0 '\n'
syscall
li $v0 11
li $a0 '\n'
syscall
ciclo:
	beq $t1 63 fineciclo
	
	div $t1 $t4
	mfhi $t2
	bnez $t2 stampaChar
	stampaSlashN:
	li $v0 11
	li $a0 '\n'
	syscall
	stampaChar:
	li $v0 11
	li $a0 ' '
	syscall
	add $t3 $t0 $t1
	lb $a0 ($t3)
	
	beq $a0 46 stampa
	beq $a0 35 stampa
	beq $a0 1 player1Symbol
	beq $a0 -1 player2Symbol
	
	player1Symbol:
	li $a0 'O'
	j stampa
	player2Symbol:
	li $a0 'X'
	stampa:
	syscall
	
	addi $t1 $t1 1
	j ciclo

fineciclo:


fineFunc:
jr $ra
