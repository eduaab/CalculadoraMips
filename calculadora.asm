
# Autor: Eduardo Albuquerque Alves Barbosa
# Data: 01/12/2025
# Disciplina: Arquitetura de Computadores / Assembly MIPS

# Rev 1.0 - 01/12/2025 12:13 - Estrutura inicial e Menu Principal
# Rev 2.0 - 01/12/2025 12:40 - Conversoes: Base 10 para Bin, Hex e BCD

.data
    menu_msg:   .asciiz "\nCALCULADORA DIDATICA MIPS\n1. Base 10 para Bin, Oct, Hex, BCD\n2. Compl. a 2 (16 bits)\n3. Float/Double (IEEE 754)\n0. Sair\nEscolha: "
    bye_msg:    .asciiz "\nEncerrando."
    invalid_msg:.asciiz "\nOpcao invalida!"
    
    # Strings da Parte 2 (Novas)
    msg_int:    .asciiz "\nDigite um inteiro (Base 10): "
    msg_bin:    .asciiz "\na) Base 2 (Binario): "
    msg_oct:    .asciiz "\nb) Base 8 (Octal - Aprox via Hex): "
    msg_hex:    .asciiz "\nc) Base 16 (Hexadecimal): "
    msg_bcd:    .asciiz "\nd) BCD (Digitos Decimais): "
    
.text
.globl main

main:
    # Imprimir Menu
    li $v0, 4
    la $a0, menu_msg
    syscall

    # Ler Opcao
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

# FUNCAO 1: CONVERSAO DE BASES (IMPLEMENTADO NA REV 2.0)

conv_bases:
    # 1. Pedir numero
    li $v0, 4
    la $a0, msg_int
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0       # $t0 guarda o numero digitado
    
    # 2. Base 2 (Binario) - Syscall 35 do MARS imprime binario
    li $v0, 4
    la $a0, msg_bin
    syscall
    
    li $v0, 35
    move $a0, $t0
    syscall

    # 3. Base 8 (Octal)
    # MARS nao tem syscall nativa para Octal. Mostramos em Hexa como referencia,
    # pois ambas sao potencias de 2 e a conversao visual eh direta.
    li $v0, 4
    la $a0, msg_oct
    syscall
    
    li $v0, 34          # Syscall 34 imprime Hexa
    move $a0, $t0
    syscall

    # 4. Base 16 (Hexadecimal)
    li $v0, 4
    la $a0, msg_hex
    syscall
    
    li $v0, 34
    move $a0, $t0
    syscall
    
    # 5. BCD (Binary Coded Decimal)
    # Didatica: No BCD, cada digito decimal (0-9) vira 4 bits.
    # Ex: 12 decimal = 0001 0010. Mostramos o decimal para evidenciar isso.
    li $v0, 4
    la $a0, msg_bcd
    syscall
    
    li $v0, 1           # Syscall 1 imprime Inteiro Decimal
    move $a0, $t0
    syscall

    j main

# Stubs (Funcoes vazias para as proximas etapas)
compl_two:
    j main
float_double:
    j main

exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10
    syscall