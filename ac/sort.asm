# EP1 por MIKAEL SHIN e RODRIGO ROSSI

.data					# declaracao de dados
	# file = referencie o arquivo .txt, incluindo o caminho da raíz até o diretorio que se encontra o arquivo. EXEMPLO:
	file: .asciiz "C:/Users/mkxn9/Documents/entrada.txt"
	gap: .asciiz " "		# armazena espaco			
	buffer: .space 1
	length: .word 0 		# tamanho do vetor
	array: .word 0 			# vetor
	sentence: .asciiz "Vetor ordenado:\n"

.text 					# instrucoes 
	li $2, 4
	la $4, sentence
	syscall
	li $11, 0 			# $11 = iterador
	la $12, array			# $12 = endereco do vetor
	li $21, 0			# $21 = flag de leitura de elemento (0 se for ' ', 1 se for numero)
	
openFile:
	la $4, file	 		# $4 = endereco de file 
	li $2, 13			# syscall: codigo para abrir o arquivo
	syscall         		# abrir arquivo
	add $17, $2, $0 		# inicializa $17 = FD 

readFile:
	add $4, $17, $0			# $4 = FD  
	la $5, buffer			# $5 = endereco do buffer 
	li $6, 1			# $6 = 1 byte a ser lido 1 byte = 1 char
	li $2, 14			# syscall: codigo para ler o arquivo
	syscall				# ler arquivo
	li $9, ' '			# $9 = ' ' 
	lb $10, ($5)			# $10 = primeiro byte lido da string 
	beq $10, $9, checkNumber	# se ($10 = ' '), salta para checkNumber
	bne $2, $0, changeNumber	# se ($2 != 0), salta para changeNumber
	bne $21, $0, storeNumberArray	# se (flag != 0), armazena elemento no vetor
	j main 

checkNumber:
	beq $21, $0, readFile		# se (flag == 0), salta para readFile
	j storeNumberArray		# se nao, salta para o storeNumberArray para armazenar o numero no vetor

changeNumber:
	andi $24, $10, 0x0F		# transforma o ASCII para inteiro
	bne $21, $0, adjustNumeral	# se (flag != 0), acerta o algarismo
	add $18, $18, $24 		# $18 = $18 + $24 (carrega decimal)
	li $21, 1			# flag = 1
	j readFile			# chama o readFile para uma nova leitura

adjustNumeral:
	mul $18, $18, 10		# $18 = $18 * 10
	add $18, $18, $24		# $18 = $18 + $24 (carrega decimal)
	li $21, 1			# flag = 1
	j readFile			# chama o readFile para uma nova leitura

storeNumberArray:
	sw $18, 0($12)			# armazena o valor de $9 no endereco 0($12)
	addi $12, $12, 4 		# $12 = endereco do vetor da proxima posicao
	addi $11, $11, 1 		# iterador = iterador + 1
	li $18, 0			# $18 = 0 (atualiza)
	li $21, 0			# flag = 0 (atualiza)
	beq $2, $0, main		# se nao ha mais nenhum elemento no arquivo, pula para a label main
	j readFile			# se ainda ha, volta para o readFile
	
main:
	jal ordena	 		# chama a label ordena para verificar qual metodo de ordenacao sera usada
	jal print 			# chama a label print para imprimir o vetor ordenado anteriormente
	li $2, 10			# syscall: codigo que finaliza o programa
	syscall				# finaliza


ordena:					# int ordena(int tam, int tipo, int *vetor)
	sw $11, length			# $11 = endereco do length (tamanho do vetor)
	la $7, ($11)			# int tam (tamanho do vetor) = $7
	li $5, 1			# int tipo (tipo da ordenacao) = $5 (0 = selection sort || 1 = quicksort)
	la $6, array 			# int* vetor = $6
	beq $5, 1, quickSortInit 	# se($5 == 1), chama o quickSortInit
	beq $5, 0, selectionSort 	# se($5 == 0), chama o selectionSort
	jr $31				# retorna para main
	
selectionSort:
	li $8, 0 			# $8 = iterador1 do vetor (primeiro loop)
	subi $10, $7, 1 		# $10 = tamanho do vetor - 1 
	
selection1stLoop:
	beq $8, $10, selection1stLoopExit 	# se (iterador1 = tamanho do vetor - 1), sai do primeiro loop
  	add $15, $8, $0 		# $15 = posicao inicial
	add $9, $8, $0 			# $9 = iterador2 no vetor (segundo loop)
	addi $9, $9, 1 			# $9 = $9 + 1 
	
selection2ndLoop:
	beq $9, $7, selection2ndLoopExit 	# se (iterador2 = tamanho do vetor), sai do segundo loop
	sll $14, $9, 2			# $14 = iterador2 * 4
	add $14, $14, $6		# $14 = $14 + endereco do vetor
	lw $13, 0 ($14)			# $13 = elemento em $9
	sll $14, $15, 2			# $14 = menor elemento atual * 4
	add $14, $14, $6		# $14 = $14 + endereco do vetor
	lw $12, 0 ($14)			# $12 = menor elemento atual ($15)
	blt $13, $12, ifSmallerThan	# se (elemento percorrido < menor elemento atual), pula para o ifSmallerThan 
	j selectionSortJump 		# se nao, pula diretamente para o selectionSortJump
	
ifSmallerThan:
	add $15, $9, $0 		# $15 = menor elemento atual
	
selectionSortJump:
	addi $9, $9, 1 			# iterador2 = iterador2 + 1 
	j selection2ndLoop 		# reinicia o segundo loop
	
selection2ndLoopExit:
	sll $14, $8, 2			# $14 = iterador1 * 4	
	add $14, $14, $6		# $14 = $14 + endereco do vetor
	lw $13, 0 ($14) 		# $13 = elemento em $8
	
	sll $12, $15, 2			# $12 = menor elemento atual * 4		
	add $12, $12, $6		# $12 = $12 + endereco do vetor
	lw $11, 0 ($12) 		# $11 = menor elemento atual ($15)
	
	sw $11, 0($14)			# as 2 linhas realizam a troca de posicao
	sw $13, 0($12)
	
	addi $8, $8, 1			# iterador1 = iterador1 + 1 
	j selection1stLoop 		# reinicia o primeiro loop
	
selection1stLoopExit:
	add $2, $7, $0 			# retorno = tamanho do vetor
	jr $31				# retorna para ordena
	
quickSortInit:
	addi $29, $29, -8		# abre espaco na pilha para salvar $31 e $30
	sw $30, 4 ($29) 		# inicializa $30 na pilha
	sw $31, 0 ($29) 		# inicializa $31 na pilha
	move $30, $29 			# $30 = $29
	li $4, 0			# $4 = 0 (esquerda)
	subi $5, $7, 0			# $5 = tamanho do vetor (direita)
	jal quickSort 			# chama a label quickSort para realizar a ordenacao
	jal quickSortFinish		# chama a label quickSortFinish para finalizar a ordenacao  

quickSort:
	addi $29, $29, -20 		# abre espaco de 20 bytes na pilha (5 registradores, 4 bytes cada um)
	sw $8, 16 ($29) 		# inicializa $8 na pilha
	sw $4, 12 ($29) 		# inicializa $4 na pilha
	sw $5, 8 ($29) 			# inicializa $5 na pilha
	sw $30, 4 ($29) 		# inicializa $30 na pilha
	sw $31, 0 ($29) 		# inicializa $31 na pilha
	move $30, $29 			# $30 = $29
	
	bge $4, $5, quickSortIf		# se (esquerda >= direita), salta para o quickSortIf
	
	jal partition			# chama a label partition
	
	add $8, $2, $0 			# $8 = pivo
	sw $8, 16 ($29) 		# inicializa $8 na pilha
	sw $4, 12 ($29) 		# inicializa $4 na pilha
	sw $5, 8 ($29) 			# inicializa $5 na pilha
	add $5, $8, $0			# $5 armazena a posicao do pivo
	jal quickSort			# realiza a chamada recursiva
	
	lw $5, 8 ($29) 			# pega $5 original da pilha
	lw $8, 16 ($29) 		# pega $8 na pilha
	addi $8, $8, 1			# $8 = posicao do pivo + 1
	add $4, $8, $0			# $4 armazena a posicao do pivo
	jal quickSort			# realiza a chamada recursiva
	
quickSortIf:
	lw $8, 16 ($29) 		# restaura $8
	lw $4, 12 ($29) 		# restaura $4
	lw $5, 8 ($29) 			# restaura $5
	lw $30, 4 ($29) 		# restaura $30
	lw $31, 0 ($29) 		# restaura $31
	addi $29, $29, 20 		# finaliza espaco na pilha
	jr $31				# retorna para quickSortInit
	
partition: 			
	sll $15, $4, 2			# $15 = $4 * 4
	add $15, $15, $6		# $15 = $15 + endereco do vetor
	lw $8, 0 ($15) 			# $8 = pivo
	add $9, $4, $0 			# $9 = registrador que define a posicao final do pivo (leftwall)
	addi $10, $4, 1 		# $10 = registrador que percorre o vetor (iterador)
	
partitionLoop:				
	beq $10, $5, partitionLoopExit	# se o iterador == direita, salta para partitionLoopExit
	
	sll $15, $10, 2			# $15 = iterador * 4
	add $15, $15, $6		# $15 = $15 + endereco do vetor
	lw $11, 0 ($15) 		# $11 = registrador que armazena o atual elemento percorrido 
	
	bge $11, $8, partitionJump	# se (atual elemento >= pivo), salta para partitionJump
	addi $9, $9, 1 			# leftwall = leftwall + 1
	
	sll $15, $10, 2			# $15 = iterador * 4
	add $15, $15, $6		# $15 = $15 + endereco do vetor
	lw $13, 0 ($15) 		# $13 = elemento em $10 
	
	sll $12, $9, 2			# $12 = leftwall * 4
	add $12, $12, $6		# $12 = $12 + endereco do vetor
	lw $11, 0 ($12) 		# $12 = elemento em $9
	
	sw $11, 0($15)			# as 2 linhas realizam a troca de posicao
	sw $13, 0($12)			# valor no indice do iterador com o valor no do leftwall

partitionJump:
	addi $10, $10, 1		# incrementa 1 no iterador do partitionLoop
	j partitionLoop			# reinicia o partitionLoop
	
partitionLoopExit:
	sll $15, $4, 2			# $15 = esquerda * 4
	add $15, $15, $6		# $15 = $15 + endereco do vetor
	lw $13, 0 ($15) 		# $13 = elemento em $4
	
	sll $12, $9, 2			# $12 = leftwall * 4
	add $12, $12, $6		# $12 = $12 + endereco do vetor
	lw $11, 0 ($12) 		# $11 = elemento em $9
	
	sw $11, 0($15)			# as 2 linhas realizam a troca de posicao
	sw $13, 0($12)
	
	add $2, $9, $0 			# retorno = posicao do pivo
	jr $31				# retorna para quickSort
	
quickSortFinish:
	lw $30, 4 ($29) 		# restaura $30
	lw $31, 0 ($29) 		# restaura $31
	addi $29, $29, 8 		# fecha espaco na pilha
	add $2, $7, $0 			# retorno = tamanho do vetor
	jr $31				# retorna para ordena
	
print:
	li $8, 0 			# $8 = iterador do vetor
	
printLoop:
	beq $8, $7, printExit		# se (iterador = tamanho do array), finaliza o print
	li $2, 1			# syscall: codigo que imprime um inteiro
	sll $9, $8, 2			# $9 = $8 * 4
	add $9, $9, $6			# $9 = $9 + endereco do vetor
	lw $10, 0 ($9)			# $10 = valor buscado no vetor
	move $4, $10			# $4 = $10, para que $4 seja impresso
	syscall				# imprime 
	li $2, 4			# syscall: codigo que imprime uma string
	la $4, gap			# $4 = espaco entre um numero e outro
	syscall 			# imprime
	addi $8, $8, 1 			# iterador = iterador + 1
	j printLoop 			# reinicia o printLoop 
	
printExit:
	jr $31				# retorna para main
