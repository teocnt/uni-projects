.globl trovaMiglioreAiRicorsivo
.data


.text
trovaMiglioreAiRicorsivo:

#preambolo
move $t0 $fp
addi $fp $sp -4
sw $t0 0($fp)
sw $sp -4($fp)
sw $ra -8 ($fp)
sw $s0 -12($fp)
sw $s1 -16($fp)
sw $s2 -20($fp)
sw $s6 -24($fp)
sw $s5 -28($fp)
sw $s7 -32($fp)

addi $sp $fp -32

#corpo
move $s0 $a0 #s0 = giocatore
move $s1 $a1 #s1 = profondit�
li $s2 1 #s2 = mossa
beq $s0 1 valMin
valMax:
li $v1 0x7FFFFFFF #v1 = score mossa migliore inizializzato massimo in caso giocatore -1
jal ciclo
valMin:
li $v1 0x80000001  #v1 score mossa migliore inizializzato minimo in caso giocatore 1
ciclo:
	beq $s2 8 fineFunzione
	move $a0 $s2  #a0 contiene mossa
	move $a1 $s0 #a1 contiene giocatore
	jal giocaMossa #provo mossa 					DA SCOMMENTARE
	beq $v0 0 prossimaMossa #se v0 == 0 (mossa non valida 
				 #salto tutto e vado alla prossima mossa)
	
	jal valutaPlancia
	mul $s6 $s0 0x7FFFFFFF	#creo valore max in base al giocatore
	beq $v0 $s6 casoMossaVittoria #se scoreScacchiera(v0) == valore massimo restituisco questa
	bnez $s1 casoProfonditaNonZero #se profondit� != 0 allora vado a ricorsvia
	
	casoProfonditaZero:
	move $s6 $v0
	beq $s0 1 maggiore
	minore:
	bge $s6 $v1 prossimaMossa #se nuovo < vecchio allora prossima mossa
	move $v1 $s6 #salvo score
	move $s5 $s2 #salvo mossa
	j prossimaMossa
	maggiore:
	ble $s6 $v1 prossimaMossa #se nuovo < vecchio allora prossima mossa
	move $v1 $s6 #salvo score
	move $s5 $s2 #salvo mossa
	j prossimaMossa	
		
	
	casoProfonditaNonZero:
	mul $a0 $s0 -1 #cambio giocatore
	addi $a1 $s1 -1 #scalo di uno la profondit�
	move $s7 $v1
	jal trovaMiglioreAiRicorsivo#chiamata ricorsiva
	move $s6 $v1
	beq $s0 1 maggiore
	minoreRic:
	bge $s6 $s7 ripristinaV1 #controllo se maggiore di precedente
	move $s5 $s2 #se maggiore di precedente $v1 gi� salvato
	j prossimaMossa
	maggioreRic:
	ble $s6 $s7 ripristinaV1 #controllo se maggiore di precedente
	move $s5 $s2 #se maggiore di precedente $v1 gi� salvato
	j prossimaMossa
	
	ripristinaV1: #se controllo qui sopra minore allora ripristino v1 salvato prima
	move $v1 $s7
	prossimaMossa:
	move $a0 $s2
	jal sgiocaMossa
	addi $s2 $s2 1
	j ciclo

casoMossaVittoria:
move $a0 $s2
jal sgiocaMossa
fineFunzione:
move $v0 $s5
#epilogo
lw $t0 0($fp)
lw $sp -4($fp)
lw $ra -8 ($fp)
lw $s0 -12($fp)
lw $s1 -16($fp)
lw $s2 -20($fp)
lw $s6 -24($fp)
lw $s5 -28($fp)
lw $s7 -32($fp)
move $fp $t0
jr $ra
