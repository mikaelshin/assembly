.data
	fibo: .word  0 : 20        # vetor que conter� os valores da sequ�ncia
	tam:  .word  20            # tamanho do vetor
.text
	la    $t0, fibo        # carregamento de endere�o do vetor
	la    $t5, tam         # carregamento do endere�o da vari�vel tam (tamanho)
	lw    $t5, 0($t5)      # carregamento do tamanho do vetor
	li    $t2, 1           # o 1 � o 1� e o 2� elemento do arranjo
	sw    $t2, 0($t0)      # fibo[0] = 1
	sw    $t2, 4($t0)      # fibo[1] = fibo[0] = 1
	addi  $t1, $t5, -2     # $t1 armazena o contador para o loop, executar� 
			       # (tamanho - 2) vezes, pois o 1� e o 2� j� foram definidos
     loop:   
	lw    $t3, 0($t0)      # retorna o valor de fibo[n] 
	lw    $t4, 4($t0)      # retorna o valor de fibo[n+1]
	add   $t2, $t3, $t4    # $t2 = fibo[n] + fibo[n+1]
	sw    $t2, 8($t0)      # armazena o fibo[n+2] = fibo[n] + fibo[n+1] no vetor
	addi  $t0, $t0, 4      # incrementa em 4 (bytes) o endere�o de fibo 
			       # (para alocarmos espa�o para o pr�ximo elemento)
	addi  $t1, $t1, -1     # decrementa o contador do loop
	bgtz  $t1, loop        # repete, enquanto o contador for maior que 0
	
	la    $a0, fibo        # adiciona o primeiro argumento para a label print (endere�o do vetor)
	add   $a1, $zero, $t5  # adiciona o segundo argumento para a label print (vari�vel "tam")
	jal   print            # chamando a label "print"
	li    $v0, 10          # chamando o sistema (syscall) para terminar a execu��o
	syscall
		
# label para printar os elementos 

.data
	espaco: .asciiz  " "  # espa�o para inseri-lo entre os n�meros
	frase:  .asciiz  "Os 20 primeiros elementos de Fibonacci s�o:\n"
.text

    print:
    	add  $t0, $zero, $a0  # $t0 recebe o endere�o do vetor 
	add  $t1, $zero, $a1  # $t1 recebe o contador para o loop (out)
	la   $a0, frase       # carregamento de endere�o a fim de imprimir a "frase"
	li   $v0, 4           # especifica o servi�o de printar uma String (n� 4)
	syscall               # printando a frase
    out:  	
	lw   $a0, 0($t0)      # carrega o n�mero de fibo load fibonacci number for syscall
	li   $v0, 1           # especifica o servi�o de printar um inteiro (n� 1)
	syscall               # printa o n�mero especificado
	
	la   $a0, espaco      # carregamento do endere�o de espa�o 
	li   $v0, 4           # especifica o servi�o de printar uma String (n� 4)
	syscall               # printa a determinada String
	
	addi $t0, $t0, 4      # incrementa o endere�o para o pr�ximo print
	addi $t1, $t1, -1     # decrementa o contador do loop
	bgtz $t1, out         # repete, enquanto o contador for maior que 0

	
