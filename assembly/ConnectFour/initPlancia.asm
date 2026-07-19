.globl initPlancia
.data

.text


initPlancia:

la $t0 plancia
li $t1 0 #indice colonne
ciclo1:
	
	beq $t1 7 fineciclo1
	li $t2 0 #indice righe
	li $t3 35 #riempimento primo elemento riga
	mul $t4 $t1 9
	addi $t5 $t4 0 #indirizzo primo elemnto riga in base a t1
	add $t6 $t5 $t0 #indirizzo plancia + offset
	sb $t3 ($t6)
	bne $t1 6 else
	j fineIf
	else: 
	li $t3 46 
	fineIf:
	addi $t2 $t2 1
	ciclo2:
		beq $t2 8 fineciclo2
		addi $t6 $t6 1
		sb $t3 ($t6)
		addi $t2 $t2 1
		j ciclo2	
	fineciclo2:
	addi $t6 $t6 1
	li $t3 35
	sb $t3 ($t6)
	addi $t1 $t1 1
	j ciclo1
	
fineciclo1:
	

fineFunc:
jr $ra