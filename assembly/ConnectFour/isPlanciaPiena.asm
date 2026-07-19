.globl isPlanciaPiena
.data
msgPlanciaPiena: .asciiz "\nla plancia è piena!\n"
.text

isPlanciaPiena:
la $t0 plancia
li $t1 0 #contatore e indice

cicloPlancia:
	beq $t1 63 fineCicloPlancia
	add $t2 $t0 $t1
	lb $t2 ($t2)
	beq $t2 46 nonPiena
	addi $t1 $t1 1
	j cicloPlancia

fineCicloPlancia:
li $v0 4
la $a0 msgPlanciaPiena
syscall
li $v0 1
j fineFunc
nonPiena:
li $v0 0




fineFunc:
jr $ra