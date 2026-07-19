.globl valutaPlancia
.data


.text
valutaPlancia:
la $t0 plancia
addi $sp $sp -4
sw $t0 ($sp)
li $t0 0 #valore scacchiera
li $t1 0 #contatore e indice

cicloPlancia:
	beq $t1 63 fineCicloPlancia
	addi $sp $sp -4
	sw $t0 ($sp)
	lw $t0 4($sp)
	add $t2 $t0 $t1
	sw $t0 4($sp)
	lw $t0 ($sp)
	addi $sp $sp 4
	lb $t3 ($t2)
	beq $t3 35 avantiProssimo
	beq $t3 46 avantiProssimo
	
		cicloControllo:
	
		orizzontale:
		li $t4 1 #indice fino a 4
			cicloOrizz:
				beq $t4 4 vittoria
				add $t5 $t2 $t4
				lb $t6 ($t5)
				bne $t6 $t3 fineOrizz
				addi $t4 $t4 1
				j cicloOrizz
			fineOrizz:
		beq $t6 35 somma1
		beq $t6 46 somma1
		j verticale  
		somma1:
		mul $t4 $t4 $t4
		mul $t4 $t4 $t3
		add $t0 $t0 $t4	
		verticale:
		li $t4 1 #indice fino a 4
			cicloVert:
				beq $t4 4 vittoria
				mul $t7 $t4 9
				add $t5 $t2 $t7
				lb $t6 ($t5)
				bne $t6 $t3 fineVert
				addi $t4 $t4 1
				j cicloVert
			fineVert:
		beq $t6 35 somma2
		beq $t6 46 somma2
		j diagonaleDestra
		somma2:
		mul $t4 $t4 $t4
		mul $t4 $t4 $t3
		add $t0 $t0 $t4	
		diagonaleDestra:
		li $t4 1 #indice fino a 4
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
		beq $t6 35 somma3
		beq $t6 46 somma3
		j diagonaleSinistra
		somma3:
		mul $t4 $t4 $t4
		mul $t4 $t4 $t3
		add $t0 $t0 $t4	
		diagonaleSinistra:
		li $t4 1 #indice fino a 4
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
	beq $t6 35 somma4
	beq $t6 46 somma4
	j fineCicloControllo
	somma4:	
	mul $t4 $t4 $t4
	mul $t4 $t4 $t3
	add $t0 $t0 $t4	
	fineCicloControllo:
	
	avantiProssimo:
	addi $t1 $t1 1
	j cicloPlancia
	
	vittoria:
	li $v0 0x7FFFFFFF
	mul $v0 $v0 $t3
	j fineFunc

fineCicloPlancia:
move $v0 $t0
fineFunc:
jr $ra