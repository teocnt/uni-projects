.globl sgiocaMossa
.data

.text

sgiocaMossa:
move $t0 $a0 #colonna da cui togliere la mossa
li $t1 0 #indice che farà +9
la $t2 plancia

ciclo:
	add $t3 $t1 $t0
	add $t4 $t2 $t3
	lb $t5 ($t4)
	bne $t5 46 fineCiclo
	addi $t1 $t1 9
	j ciclo

fineCiclo:
li $t5 46
sb $t5 ($t4)

fineFunc:
jr $ra