.globl chiediMossa

.data
richiestaMossa: .asciiz "\ninserisci la colonna in cui giocare il prossimo dischetto(da 1 a 7) oppure 8 per terminare la partita-->"
msgOutOfRangeMossa: .asciiz "\ndevi inserire una colonna tra 1 e 7!!\n"
msgColonnaPiena: .asciiz "\nla colonna selezionata è piena, inserire una nuova mossa--> "
.text

chiediMossa:

	la $t0 plancia
	j richiesta
	
	colonnaPiena:
	li $v0 4
	la $a0 msgColonnaPiena
	syscall
	j inputMossa
	
	mossaOutOfRange:
	li $v0 4
	la $a0 msgOutOfRangeMossa
	syscall
	
	richiesta:
	li $v0 4
	la $a0 richiestaMossa
	syscall
	inputMossa:
	li $v0 5
	syscall
	
	beq $v0 8 finePartita
	blt $v0 1 mossaOutOfRange
	bgt $v0 7 mossaOutOfRange
	
	add $t2 $t0 $v0
	lb $t1 ($t2)
	bne $t1 46 colonnaPiena
	
	j fineFunc
	
	finePartita:
	li $v0 -1
	
fineFunc:
jr $ra