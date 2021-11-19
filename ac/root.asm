## atividade 2
     
.globl main 
main: 
     addi $a0, $zero, 1             # a = 1
     addi $a1, $zero, 2             # b = 2
     addi $a2, $zero, 3             # c = 3
     addi $a3, $zero, 4             # c1 = 4
     addi $t0, $zero, 5             # c2 = 5
     addi $t1, $zero, 6             # c3 = 6
     
     subi $sp, $sp, 16              # abrindo espaço na pilha 
     sw $ra, 12($sp)		    # salvando registrador $ra
     sw $fp, 8($sp)		    # salvando registrador $fp
     sw $t0, 4($sp)		    # salvando registrador temporário $t0 (int c2)
     sw $t1, 0($sp)		    # salvando registrador temporário $t1 (int c3)
     move $fp, $sp		    # $fp apontando para o topo da pilha, até então
     
     jal calcula_raiz               # chamando procedimento calcula_raiz 
     
     lw $fp, 4($sp)		    # restaurando registrador $fp
     lw $ra, 8($sp)		    # restaurando registrador $ra
     addi $sp, $sp, 12              # desfazendo-se do topo
     
     jr $ra			    # fim do programa
     
     
.globl calcula_raiz
calcula_raiz:

     subi $sp, $sp, 4		    # abrindo espaço na pilha 
     sw $s0, 0($sp)		    # salvando registrador $s0
     
     mul $s0, $a1, -1		    # $s0 = b * (-1)
     move $s0, $sp                  # $s0 apontando para o topo da pilha, até então
     
     jal sqrt                       # chamando procedimento sqrt 
     
     add $s0, $s0, $v1		    # $s0 = b * (-1) + 1
     move $v0, $s0		    # $v0 = $s0 = -1 ((armazenando valor do retorno))
     
     lw $s0, 0($sp)                 # restaurando registrador $s0
     addi $sp, $sp, 4		    # desfazendo-se do topo desse procedimento 
     
     jr $ra			    # retorna para main
     
     
.globl sqrt
sqrt:
     
     jal calcula_delta		    # chamando procedimento calcula_delta
     
     addi $v1, $zero, 1		    # $v1 = 1 (retorno do próprio procedimento)
     
     jr $ra			    # retorna para calcula_raiz
     
     
.globl calcula_delta
calcula_delta:
     
     subi $sp, $sp, 12		    # abrindo espaço na pilha 
     sw $s1, 8($sp)     	    # salvando registrador $s1
     sw $s2, 4($sp)		    # salvando registrador $s2
     sw $s3, 0($sp)		    # salvando registrador $s3
     
     mul $s1, $a1, 4		    # $s1 = b * 4
     mul $s2, $a0, 4                # $s2 = 4 * a 
     mul $s3, $s2, $a2              # $s3 = 4 * a * c
     sub $s1, $s1, $s3              # $s1 = b * 4 - (4 * a * c)
 
     move $v0, $s1		    # $v0 = $s1 (armazenando valor do retorno)
     lw $s3, 0($sp)                 # restaurando registrador $s3
     lw $s2, 4($sp)		    # restaurando registrador $s3
     lw $s1, 8($sp)                 # restaurando registrador $s3
     addi $sp, $sp, 12              # desfazendo-se do topo desse procedimento 
     
     jr $ra			    # retorna para sqrt