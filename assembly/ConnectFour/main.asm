.globl plancia
.globl main
.data
plancia: .space 63
benvenuto: .asciiz "\nbenvenuto, vuoi avviare una partita?(si:S, no:N)--> "
msgCharNotValid: .asciiz "\n\ndevi inserire o S o N non altri caratteri!!\n"
quantiGiocatori: .asciiz "\n\ninserisci il numero di giocatori(1 o 2 o -1 per tornare indietro)--> "
msgPlayerErrorSelection: .asciiz "\no 1 o 2 giocatori non di più!!"
msgVittoria1: .asciiz "\ncomplimenti giocatore, 1 hai vinto!!\n"
msgVittoria2: .asciiz "\ncomplimenti giocatore, 2 hai vinto!!\n"
difficolta: .asciiz "\nseleziona la difficoltà tra 0 e 4 (0: molto facile, 1: facile, 2: medio, 3: difficilino, 4: strong)--> "
msgOutOfRangeDifficolta: .asciiz "\n devi scegliere una difficoltà tra 0 e 4\n"
msgVittoriaAi: .asciiz "\npensavi di battermi?;D\n"
msgChiusura: .asciiz "\nbene alla prossima allora :)!!\n"
turnoGiocatore: .asciiz "\n è il tuo turno giocatore "
msgPareggio: .asciiz "\npartita terminata in parità :/\n"
.text

main:
j cicloRichiestaPartita

errorSelectionNumberOfPlayer:
li $v0 4
la $a0 msgPlayerErrorSelection
syscall
j siPartita
carattereNonValido:
li $v0 4
la $a0 msgCharNotValid
syscall
cicloRichiestaPartita:
	li $v0 4
	la $a0 benvenuto
	syscall
	li $v0 12
	syscall
	blt $v0 65 nonMaiusc
	bgt $v0 90 nonMaiusc
	j giaMaiusc
	nonMaiusc:
	addi $v0 $v0 -32
	giaMaiusc:
	beq $v0 'S' siPartita
	beq $v0 'N' fine
	j carattereNonValido 
	
	siPartita:
		li $v0 4
		la $a0 quantiGiocatori
		syscall
		li $v0 5
		syscall
		beq $v0 1 againstAi
		beq $v0 2 againstP2
		beq $v0 -1 cicloRichiestaPartita
		j errorSelectionNumberOfPlayer
		
		againstAi:
			j richiestaDifficolta
			
			outOfRangeDifficolta:
			li $v0 4
			la $a0 msgOutOfRangeDifficolta
			syscall
			
			richiestaDifficolta:
			li $v0 4
			la $a0 difficolta
			syscall
			li $v0 5
			syscall
			bltz $v0 outOfRangeDifficolta
			bgt $v0 4 outOfRangeDifficolta 
			move $s1 $v0
			partitaAi:
			jal initPlancia
			li $s0 1 #turno giocatore 1
			cicloPartitaAi:
			jal disegnaPlancia
			jal checkVittoria
			beq $v0 1 vittoria1
			beq $v0 -1 vittoriaAi
			jal isPlanciaPiena
			beq $v0 1 pareggio
			beq $s0 -1 turnoAi
			turnoPlayer:
			jal chiediMossa
			bne $v0 -1 avantiPartitaAi
			j vittoriaAi		
			turnoAi:
			move $a0 $s0
			move $a1 $s1
			jal trovaMiglioreAiRicorsivo
			
			avantiPartitaAi:
			move $a0 $v0
			move $a1 $s0  
			jal giocaMossa
			mul $s0 $s0 -1
			j cicloPartitaAi
			
		againstP2:
			jal initPlancia
			li $s0 1 #turno giocatore 1
			cicloPartita:
				jal disegnaPlancia
				jal checkVittoria
				beq $v0 1 vittoria1
				beq $v0 -1 vittoria2
				move $a0 $s0
				jal isPlanciaPiena
				beq $v0 1 pareggio
				jal chiediMossa
				bne $v0 -1 avantiPartita
				beq $s0 1 vittoria2
				beq $s0 -1 vittoria1
				avantiPartita:
				move $a0 $v0
				move $a1 $s0  
				jal giocaMossa
				mul $s0 $s0 -1
				j cicloPartita
			
		vittoria1:
		li $v0 4
		la $a0 msgVittoria1
		syscall
		j finePartita
		vittoria2:
		li $v0 4
		la $a0 msgVittoria2
		syscall
		j finePartita
		pareggio:
		li $v0 4
		la $a0 msgPareggio
		syscall
		j finePartita
		vittoriaAi:
		li $v0 4
		la $a0 msgVittoriaAi
		syscall
		finePartita:
		
	

j cicloRichiestaPartita

fine:
li $v0 4
la $a0 msgChiusura
syscall
li $v0 10
syscall





#main:
li $s0 1
jal initPlancia
cicloInf:
	jal disegnaPlancia
	jal checkVittoria
	beq $v0 1 vittoria1Prova
	beq $v0 -1 vittoria2Prova
	jal isPlanciaPiena
	beq $v0 1 fineProva
	jal valutaPlancia
	move $s7 $v0
	li $v0 4
	la $a0 msgPareggio
	syscall
	li $v0 1
	move $a0 $s7
	syscall
	li $v0 11
	li $a0 '\n'
	syscall
	li $v0 4
	la $a0 turnoGiocatore
	syscall
	li $v0 1
	move $a0 $s0
	syscall
	li $v0 11
	li $a0 '\n'
	syscall
	
	jal chiediMossa
	beq $v0 -1 fineProva
	move $a0 $v0
	move $a1 $s0
	jal giocaMossa
	
	mul $s0 $s0 -1
	j cicloInf
	

vittoria1Prova:
		li $v0 4
		la $a0 msgVittoria1
		syscall
		j fineProva
vittoria2Prova: 
		li $v0 4
		la $a0 msgVittoria2
		syscall
fineProva:
li $v0 10
syscall
