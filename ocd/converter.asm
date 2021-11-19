.data
	msg: .asciiz "Digite um número decimal: "
	num: .asciiz ""
.align 2

.text

.globl start
    start:
	li $v0, 4		#
	la $a0, msg		#
	syscall			## imprimindo a msg e
	li $v0, 5		## armazenando o valor
	syscall			#
	move $a0, $v0		#

	jal init		# salta para a label init, guardando o link
	
	li $v0, 11		#
	li $a0, 10		## gerando uma nova linha 
	syscall			#

	j start			# chamada ao start, reiniciando todo o processo
				
   init:
	add  $t0, $zero, $a0 	# $t0 recebe o valor decimal
	add  $t1, $zero, $zero 	# $t1 recebe 0
	addi $t3, $zero, 1 	# $t3 recebe 1
	sll  $t3, $t3, 31	# desloca essa lógica para esquerda
	addi $t4, $zero, 32	# $t4 recebe 32 (contador do loop)
   loop:
	and  $t1, $t0, $t3 	# $t1 recebe o resultado de ($t0 e $t3) 
	beq  $t1, $zero, print	# se $t1 = 0, salta para a label print A

	add  $t1, $zero, $zero	# 
	addi $t1, $zero, 1 	## $t1 recebe 1
	
	j    print		# chama a label print
   print: 
	li $v0, 1		#
	move $a0, $t1		## printa o inteiro guardado (1 ou 0)
	syscall			#

	srl $t3, $t3, 1		# descoloca em 1 a lógica
	addi $t4, $t4, -1	# decrementa em 1 o contador
	bne $t4, $zero, loop	# se o contador NÃO for 0 continua o loop, 
				# senão retorna e salta para a linha 21
	jr $ra			# retorna
