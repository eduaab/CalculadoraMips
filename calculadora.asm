# Eduardo Albuquerque Alves Barbosa
# 01/12/2025
# Rev 1.0 - 01/12/2025 12:13 - Estrutura inicial e Menu Principal
.data
    menu_msg:   .asciiz "CALCULADORA DIDATICA MIPS\n1. Base 10 para Bin, Oct, Hex, BCD\n2. Compl. a 2 (16 bits)\n3. Float/Double (IEEE 754)\n0. Sair\nEscolha: "
    bye_msg:    .asciiz "\nEncerrando."
    invalid_msg:.asciiz "\nOpcao invalida!"
    
.text
.globl main

main:
    # Imprimir Menu (Syscall 4)
    li $v0, 4
    la $a0, menu_msg
    syscall

    # Ler Opcao (Syscall 5)
    li $v0, 5
    syscall
    move $s0, $v0       # Salva opcao em $s0

    # Verificacoes
    beq $s0, 0, exit_prog
    beq $s0, 1, conv_bases
    beq $s0, 2, compl_two
    beq $s0, 3, float_double
    
    # Opcao Invalida
    li $v0, 4
    la $a0, invalid_msg
    syscall
    j main

# Stubs (Funcoes vazias para compilar agora)
conv_bases:
    j main
compl_two:
    j main
float_double:
    j main

exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10      # Syscall exit
    syscall