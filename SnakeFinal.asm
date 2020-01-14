.data

larguraTela: 	.word 64
alturaTela: 	.word 64
fundo: 		.word	0x000000
cobra: 		.word	0xFFFFFF
cauda: 		.word   0xF23A0F
inicioCobraX:	.word 32
inicioCobraY:	.word 32
inicioCaudaX:   .word 32
inicioCaudaY:   .word 36
posicaoX: .word 32
posicaoY: .word 32
posicaoCaudaX:   .word 32
posicaoCaudaY:   .word 36
speed: .word 150
direcao: .word 0
frutaX: .word 0
frutaY: .word 0
posicaoEscritaArray: .word 16
direcaoCauda: .word 119
posicaoArray: .word 0
direcaoArray: .word 0:100
pontuacao: .word 0
gameOver: .asciiz "Fim de jogo: "

.text
main:
	lw $a0, larguraTela
	lw $a1, alturaTela
	mul $a1, $a1, $a0
	mul $a1, $a1, 4 
	add $a1, $a1, $gp 
	add $a0, $gp, $zero 
	lw $a2, fundo
	addi $t5, $zero, -1
		

bordas:
	lw $t1, larguraTela
	mul $t1, $t1, 4
	addi $t3, $zero, 56
	mul $t3, $t3, 256
	lw $a3, cobra
	addi $a0, $gp, 0
	addi $t2, $zero, 0
	
loop:
	beq $t2, $t1, paredes
	sw $a3, 0($a0)
	add $a0, $gp, $t3
	sw $a3, 0($a0)
	addi $t3, $t3, 4
	addi $t2, $t2, 4
	add $a0, $gp, $t2
	j loop

paredes:
	addi $t2, $zero, 0
	addi $t3, $zero, 252
	
loop2:
	beq $t2, 14592, obstaculos
	add $a0, $gp, $t2 
	sw $a3, 0($a0)
	add $a0, $gp, $t3
	sw $a3, 0($a0)
	addi $t2, $t2, 256
	addi $t3, $t3, 256
	j loop2
	
obstaculos:
	addi $t2, $zero, 1560
	addi $t3, $zero, 12964

loop3:
	beq $t2, 1624, obstaculos2
	add $a0, $gp, $t2
	sw $a3, 0($a0)
	add $a0, $gp, $t3
	sw $a3, 0($a0)
	addi $t2, $t2, 4
	addi $t3, $t3, 4
	j loop3
	
obstaculos2:
	addi $t2, $zero, 1560
	addi $t3, $zero, 9184

loop4: 
	beq $t2, 5400, geraCobra
	add $a0, $gp, $t2
	sw $a3, 0($a0)
	add $a0, $gp, $t3
	sw $a3, 0($a0)
	addi $t2, $t2, 256
	addi $t3, $t3, 256
	j loop4
	
geraCobra:
	lw $a0, inicioCobraX
	lw $a1, inicioCobraY
	jal pegaEndereco
	add $a0, $v0, $zero
	lw $a2, cobra
	jal pintaPixel
	lw $a0, inicioCobraX
	addi $a1, $a1, 1
	jal pegaEndereco
	add $a0, $v0, $zero
	lw $a2, cobra
	jal pintaPixel
	lw $a0, inicioCobraX
	addi $a1, $a1, 1
	jal pegaEndereco
	add $a0, $v0, $zero
	lw $a2, cobra
	jal pintaPixel
	lw $a0, inicioCobraX
	addi $a1, $a1, 1
	jal pegaEndereco
	add $a0, $v0, $zero
	lw $a2, cobra
	jal pintaPixel	
	j iniciaDados
	
	
	
iniciaDados:
	addi $t0, $zero, 0
	addi $t1, $zero, 119
	sw $t1, direcaoArray($t0)	
	addi $t0, $t0, 4
	sw $t1, direcaoArray($t0)
	addi $t0, $t0, 4
	sw $t1, direcaoArray($t0)
	addi $t0, $t0, 4
	sw $t1, direcaoArray($t0)
	j geraCauda
	

geraCauda:
	lw $a0, inicioCaudaX
	lw $a1, inicioCaudaY
	jal pegaEndereco
	add $a0, $v0, $zero
	lw $a2, fundo
	jal pintaPixel
	j criaFruta
	
pintaPixel:
	sw $a2, 0($a0)		
	jr $ra
			
pegaEndereco:
	lw $v0, alturaTela
	mul $v0, $v0, $a1
	add $v0, $v0, $a0
	mul $v0, $v0, 4
	add $v0, $v0, $gp
	jr $ra
	
subir:
	lw $a0, speed
	jal velocidade
	lw $a0, posicaoX
	lw $a1, posicaoY
	lw $t0, posicaoY
	addiu $t0, $t0, -1
	sw $t0, posicaoY
	add $a1, $t0, $zero
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $t4, 0($a0)
	lw $a2, cobra
	beq $t4, $a2, exit
	jal pintaPixel
	j salvaDirecao

descer:
	lw $a0, speed
	jal velocidade
	lw $a0, posicaoX
	lw $a1, posicaoY
	lw $t0, posicaoY
	addiu $t0, $t0, 1
	sw $t0, posicaoY
	add $a1, $t0, $zero
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $t4, 0($a0)
	lw $a2, cobra
	beq $t4, $a2, exit
	jal pintaPixel
	j salvaDirecao

direita:
	lw $a0, speed
	jal velocidade
	lw $a0, posicaoX
	lw $a1, posicaoY
	lw $t0, posicaoX
	addiu $t0, $t0, 1
	sw $t0, posicaoX
	add $a0, $t0, $zero
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $t4, 0($a0)
	lw $a2, cobra
	beq $t4, $a2, exit
	jal pintaPixel
	j salvaDirecao
	
esquerda:
	lw $a0, speed
	jal velocidade
	lw $a0, posicaoX
	lw $a1, posicaoY
	lw $t0, posicaoX
	addiu $t0, $t0, -1
	sw $t0, posicaoX
	add $a0, $t0, $zero
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $t4, 0($a0)
	lw $a2, cobra
	beq $t4, $a2, exit
	jal pintaPixel
	j salvaDirecao


checaEntrada:
	li $t0, 0xffff0000
	lw $a1, 4($t0)
	lw $t1, direcao
	beq $t1, 119, subida
	beq $t1, 115, descida
	beq $t1, 100, direitida
	beq $t1, 97, esquerdida
volta:
	sw $a1, direcao
	lw $t1, direcao
	beq $t1, 119, vaiSubir
	beq $t1, 115, vaiDescer
	beq $t1, 100, vaiParaDireita
	beq $t1, 97, vaiParaEsquerda
	j checaEntrada

subida:
	beq $a1, 115, setSubida
	j volta
setSubida:
	addi $a1, $zero, 119
	j volta
	
descida:
	beq $a1, 119, setDescida
	j volta
setDescida: 
	addi $a1, $zero, 115
	j volta

direitida:
	beq $a1, 97, setDireitida
	j volta
setDireitida:
	addi $a1, $zero, 100
	j volta
	
esquerdida: 
	beq $a1, 100, setEsquerda
	j volta
setEsquerda:
	addi $a1, $zero, 97
	j volta
	 
vaiSubir:
	addi $t1, $zero, 119	
	sw $t1, direcao
	j subir
	
vaiDescer:
	addi $t1, $zero, 115	
	sw $t1, direcao
	j descer
	
vaiParaDireita:
	addi $t1, $zero, 100	
	sw $t1, direcao
	j direita
	
vaiParaEsquerda:
	addi $t1, $zero, 97	
	sw $t1, direcao
	j esquerda

checaCauda:
	jal verificaColisaoFruta
	lw $t0, posicaoArray
	lw $t1, direcaoArray($t0)
	sw $t1, direcaoCauda
	beq $t0, 396, resetPosicao
	addi $t0, $t0, 4
	sw $t0, posicaoArray
	j moveCauda
	
resetPosicao:
	addi $t2, $zero, 0
	sw $t2, posicaoArray
	j moveCauda


salvaDirecao:
	lw $t0, posicaoEscritaArray
	lw $t3, direcao
	sw $t3, direcaoArray($t0)
	lw $t3, direcaoArray($t0)	
	beq $t0, 396, resetPosicaoEscrita
	addi $t0, $t0, 4
	sw $t0, posicaoEscritaArray
	j checaCauda

resetPosicaoEscrita:
	addi $t2, $zero, 0
	sw $t2, posicaoEscritaArray
	j checaCauda
	
moveCauda:

	lw $t1, direcaoCauda
	beq $t1, 119, subirCauda
	beq $t1, 115, descerCauda
	beq $t1, 100, direitaCauda
	beq $t1, 97,  esquerdaCauda
	
descerCauda:
	lw $a0, posicaoCaudaX
	lw $a1, posicaoCaudaY
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $a2, fundo
	jal pintaPixel
	lw $t0, posicaoCaudaY
	addi $t0, $t0, +1
	sw $t0, posicaoCaudaY
	j checaEntrada

subirCauda:
	lw $a0, posicaoCaudaX
	lw $a1, posicaoCaudaY
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $a2, fundo
	jal pintaPixel
	lw $t0, posicaoCaudaY
	addi $t0, $t0, -1
	sw $t0, posicaoCaudaY
	j checaEntrada

direitaCauda:
	lw $a0, posicaoCaudaX
	lw $a1, posicaoCaudaY
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $a2, fundo
	jal pintaPixel
	lw $t0, posicaoCaudaX
	addi $t0, $t0, +1
	sw $t0, posicaoCaudaX
	j checaEntrada
	

esquerdaCauda:
	lw $a0, posicaoCaudaX
	lw $a1, posicaoCaudaY
	jal pegaEndereco
	add $a0, $zero, $v0
	lw $a2, fundo
	jal pintaPixel
	lw $t0, posicaoCaudaX
	addi $t0, $t0, -1
	sw $t0, posicaoCaudaX
	j checaEntrada
	

criaFruta:
	li $v0, 42
	li $a1, 62
	syscall
	addiu $a0, $a0, 1
	sw $a0, frutaX
	syscall
	li $v0, 42
	li $a1, 54
	syscall
	addiu $a0, $a0, 1
	sw $a0, frutaY
	syscall
	lw $a0, frutaX
	lw $a1, frutaY
	jal pegaEndereco
	add $a0, $zero, $v0	
	lw $a2, cobra
	lw $a3, 0($a0)
	beq $a2, $a3, criaFruta
	addi $t5, $t5, 1
	lw $a2, cauda
	jal pintaPixel
	jal placar
	lw $t1, speed
	addi $t1, $t1, -3
	sw $t1, speed
	li $v0, 31
	li $a0, 79
	li $a1, 150
	li $a2, 7
	li $a3, 127
	syscall	
	
	li $a0, 96
	li $a1, 250
	li $a2, 7
	li $a3, 127
	syscall
	j checaEntrada

verificaColisaoFruta:
	lw $t1, posicaoX
	lw $t3, frutaX
	lw $t2, posicaoY
	lw $t4, frutaY
	
	beq $t1, $t3, testeEmY
	addi $v1, $zero, 1
	jr $ra
	
testeEmY:
	beq $t2, $t4, adquiriuFruta
	addi $v1, $zero, 1
	jr $ra


adquiriuFruta:
	move $a0, $t3
	li $v0, 1
	syscall 
	lw $t3, posicaoArray
	beqz $t3, vaiProFimDoArray
	addi $t3, $t3, -4
	j back
vaiProFimDoArray:
	addi $t3, $zero, 396
back:
	sw $t3, posicaoArray
	lw $t1, direcaoCauda
	beq $t1, 119, cresceParaBaixo
	beq $t1, 115, cresceParaCima
	beq $t1, 100, cresceParaEsquerda
	beq $t1, 97, cresceParaDireita
	
cresceParaBaixo:
	lw $a1, posicaoCaudaY
	addi $a1, $a1, 1
	sw $a1, posicaoCaudaY
	jal criaFruta
	j checaEntrada

cresceParaCima:
	lw $a1, posicaoCaudaY
	addi $a1, $a1, -1
	sw $a1, posicaoCaudaY
	jal criaFruta
	j checaEntrada

cresceParaDireita:
	lw $a1, posicaoCaudaX
	addi $a1, $a1, 1
	sw $a1, posicaoCaudaX
	jal criaFruta
	j checaEntrada

cresceParaEsquerda:
	lw $a1, posicaoCaudaX
	addi $a1, $a1, -1
	sw $a1, posicaoCaudaX
	jal criaFruta
	j checaEntrada

velocidade:
	li $v0, 32
	syscall
	jr $ra	
	
placar:
	div $t4, $t5, 10
	mul $t3, $t4, 10
	sub $t3, $t5, $t3
	
	add $a0, $gp, $zero
	lw $a2, cobra
	lw $a3, fundo
	beq $t3, 0, zero
	beq $t3, 1, um
	beq $t3, 2, dois
	beq $t3, 3, tres
	beq $t3, 4, quatro
	beq $t3, 5, cinco
	beq $t3, 6, seis
	beq $t3, 7, sete
	beq $t3, 8, oito
	beq $t3, 9, nove


zero:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a2, 15856($a0)
sw $a2, 15608($a0)
sw $a3, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

um: 
sw $a2, 16120($a0)
sw $a3, 16116($a0)
sw $a3, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a3, 15604($a0)
sw $a3, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a3, 15344($a0)
sw $a2, 15096($a0)
sw $a3, 15092($a0)
sw $a3, 15088($a0)
j placar2

dois:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a3, 15864($a0)
sw $a3, 15860($a0)
sw $a2, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a3, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

tres:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a3, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

quatro:
sw $a2, 16120($a0)
sw $a3, 16116($a0)
sw $a3, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a3, 15092($a0)
sw $a2, 15088($a0)
j placar2

cinco:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a3, 15352($a0)
sw $a3, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

seis:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a2, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a3, 15352($a0)
sw $a3, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

sete:
sw $a2, 16120($a0)
sw $a3, 16116($a0)
sw $a3, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a3, 15604($a0)
sw $a3, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a3, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2

oito:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a2, 15860($a0)
sw $a2, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a2, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)


nove:
sw $a2, 16120($a0)
sw $a2, 16116($a0)
sw $a2, 16112($a0)
sw $a2, 15864($a0)
sw $a3, 15860($a0)
sw $a3, 15856($a0)
sw $a2, 15608($a0)
sw $a2, 15604($a0)
sw $a2, 15600($a0)
sw $a2, 15352($a0)
sw $a3, 15348($a0)
sw $a2, 15344($a0)
sw $a2, 15096($a0)
sw $a2, 15092($a0)
sw $a2, 15088($a0)
j placar2


placar2:
	div $t4, $t5, 10
	add $a0, $gp, $zero
	lw $a2, cobra
	lw $a3, fundo
	beq $t4, 0, zero2
	beq $t4, 1, um2
	beq $t4, 2, dois2
	beq $t4, 3, tres2
	beq $t4, 4, quatro2
	beq $t4, 5, cinco2
	beq $t4, 6, seis2
	beq $t4, 7, sete2
	beq $t4, 8, oito2
	beq $t4, 9, nove2	

zero2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a2, 15840($a0)
sw $a2, 15592($a0)
sw $a3, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra

um2: 
sw $a2, 16104($a0)
sw $a3, 16100($a0)
sw $a3, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a3, 15588($a0)
sw $a3, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a3, 15328($a0)
sw $a2, 15080($a0)
sw $a3, 15076($a0)
sw $a3, 15072($a0)
jr $ra

dois2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a3, 15848($a0)
sw $a3, 15844($a0)
sw $a2, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a3, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra

tres2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a3, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra

quatro2:
sw $a2, 16104($a0)
sw $a3, 16100($a0)
sw $a3, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a3, 15076($a0)
sw $a2, 15072($a0)
jr $ra

cinco2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a3, 15336($a0)
sw $a3, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra

seis2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a2, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a3, 15336($a0)
sw $a3, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra

sete2:
sw $a2, 16104($a0)
sw $a3, 16100($a0)
sw $a3, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a3, 15588($a0)
sw $a3, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a3, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
j placar2

oito2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a2, 15844($a0)
sw $a2, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a2, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra


nove2:
sw $a2, 16104($a0)
sw $a2, 16100($a0)
sw $a2, 16096($a0)
sw $a2, 15848($a0)
sw $a3, 15844($a0)
sw $a3, 15840($a0)
sw $a2, 15592($a0)
sw $a2, 15588($a0)
sw $a2, 15584($a0)
sw $a2, 15336($a0)
sw $a3, 15332($a0)
sw $a2, 15328($a0)
sw $a2, 15080($a0)
sw $a2, 15076($a0)
sw $a2, 15072($a0)
jr $ra
	
exit:
	li $v0, 31
	li $a0, 28
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall
		
	li $a0, 33
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall
	
	li $a0, 47
	li $a1, 1000
	li $a2, 32
	li $a3, 127
	syscall
	
	li $v0, 56
	la $a0, gameOver
	sw $t5, pontuacao
	lw $a1, pontuacao
	syscall
