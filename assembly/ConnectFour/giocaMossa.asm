.globl giocaMossa
.data



.text
giocaMossa:
move $t0 $a0#mossa colonna
move $t1 $a1#giocatore
la $t2 plancia
li $t3 0 #contatore e indice
add $t5 $t2 $t0
lb $t5 ($t5)
bne $t5 46 colonnaPiena
cicloPosizioneColonna:
	add $t4 $t3 $t0
	add $t4 $t4 $t2
	lb $t5 ($t4)
	bne $t5 46 fineCiclo
	addi $t3 $t3 9 
	j cicloPosizioneColonna
	
	
fineCiclo:
addi $t3 $t3 -9
add $t4 $t3 $t0
add $t4 $t4 $t2
sb $t1 ($t4)
li $v0 1
j fineFunc

colonnaPiena:
li $v0 0

fineFunc:
jr $ra

