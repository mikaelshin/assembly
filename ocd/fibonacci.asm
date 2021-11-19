.data
	fibo: .word  0 : 20        # vetor que conterá os valores da sequência
	tam:  .word  20            # tamanho do vetor
.text
	la    $t0, fibo        # carregamento de endereço do vetor
	la    $t5, tam         # carregamento do endereço da variável tam (tamanho)
	lw    $t5, 0($t5)      # carregamento do tamanho do vetor
	li    $t2, 1           # o 1 é o 1º e o 2º elemento do arranjo
	sw    $t2, 0($t0)      # fibo[0] = 1
	sw    $t2, 4($t0)      # fibo[1] = fibo[0] = 1
	addi  $t1, $t5, -2     # $t1 armazena o contador para o loop, executará 
			       # (tamanho - 2) vezes, pois o 1º e o 2º já foram definidos
     loop:   
	lw    $t3, 0($t0)      # retorna o valor de fibo[n] 
	lw    $t4, 4($t0)      # retorna o valor de fibo[n+1]
	add   $t2, $t3, $t4    # $t2 = fibo[n] + fibo[n+1]
	sw    $t2, 8($t0)      # armazena o fibo[n+2] = fibo[n] + fibo[n+1] no vetor
	addi  $t0, $t0, 4      # incrementa em 4 (bytes) o endereço de fibo 
			       # (para alocarmos espaço para o próximo elemento)
	addi  $t1, $t1, -1     # decrementa o contador do loop
	bgtz  $t1, loop        # repete, enquanto o contador for maior que 0
	
	la    $a0, fibo        # adiciona o primeiro argumento para a label print (endereço do vetor)
	add   $a1, $zero, $t5  # adiciona o segundo argumento para a label print (variável "tam")
	jal   print            # chamando a label "print"
	li    $v0, 10          # chamando o sistema (syscall) para terminar a execução
	syscall
		
# label para printar os elementos 

.data
	espaco: .asciiz  " "  # espaço para inseri-lo entre os números
	frase:  .asciiz  "Os 20 primeiros elementos de Fibonacci são:\n"
.text

    print:
    	add  $t0, $zero, $a0  # $t0 recebe o endereço do vetor 
	add  $t1, $zero, $a1  # $t1 recebe o contador para o loop (out)
	la   $a0, frase       # carregamento de endereço a fim de imprimir a "frase"
	li   $v0, 4           # especifica o serviço de printar uma String (nº 4)
	syscall               # printando a frase
    out:  	
	lw   $a0, 0($t0)      # carrega o número de fibo load fibonacci number for syscall
	li   $v0, 1           # especifica o serviço de printar um inteiro (nº 1)
	syscall               # printa o número especificado
	
	la   $a0, espaco      # carregamento do endereço de espaço 
	li   $v0, 4           # especifica o serviço de printar uma String (nº 4)
	syscall               # printa a determinada String
	
	addi $t0, $t0, 4      # incrementa o endereço para o próximo print
	addi $t1, $t1, -1     # decrementa o contador do loop
	bgtz $t1, out         # repete, enquanto o contador for maior que 0

	
