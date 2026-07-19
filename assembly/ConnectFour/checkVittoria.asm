.globl checkVittoria
.data


.text
checkVittoria:
la $t0 plancia
li $t1 0 #contatore e indice
cicloPlancia:
	beq $t1 63 fineCicloPlancia
	add $t2 $t0 $t1
	lb $t3 ($t2)
	beq $t3 35 avantiProssimo
	beq $t3 46 avantiProssimo
	
	cicloControllo:
	
		li $t4 1 #indice fino a 4
		orizzontale:
			cicloOrizz:
				beq $t4 4 vittoria
				add $t5 $t2 $t4
				lb $t6 ($t5)
				bne $t6 $t3 fineOrizz
				addi $t4 $t4 1
				j cicloOrizz
			fineOrizz:
		li $t4 1 #indice fino a 4  
		verticale:
			cicloVert:
				beq $t4 4 vittoria
				mul $t7 $t4 9
				add $t5 $t2 $t7
				lb $t6 ($t5)
				bne $t6 $t3 fineVert
				addi $t4 $t4 1
				j cicloVert
			fineVert:
		
		li $t4 1 #indice fino a 4
		diagonaleDestra:
			cicloDiagDX:
				beq $t4 4 vittoria
				mul $t7 $t4 9
				add $t7 $t7 $t4
				add $t5 $t2 $t7
				lb $t6 ($t5)
				bne $t6 $t3 fineDiagDX
				addi $t4 $t4 1
				j cicloDiagDX
			fineDiagDX:
		li $t4 1 #indice fino a 4
		diagonaleSinistra:
			cicloDiagSX:
				beq $t4 4 vittoria
				mul $t7 $t4 9
				sub $t7 $t7 $t4
				add $t5 $t2 $t7
				lb $t6 ($t5)
				bne $t6 $t3 fineDiagSX
				addi $t4 $t4 1
				j cicloDiagSX
			fineDiagSX:
	fineCicloControllo:
	
	avantiProssimo:
	addi $t1 $t1 1
	j cicloPlancia
	
	vittoria:
	move $v0 $t3
	j fineFunc

fineCicloPlancia:
li $v0 0

fineFunc:
jr $ra