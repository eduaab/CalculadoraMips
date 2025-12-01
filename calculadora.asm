# Autor: Eduardo Albuquerque Alves Barbosa
# Data: 01/12/2025

# Rev 1.0 - 01/12/2025 12:13 - Estrutura inicial e Menu Principal
# Rev 2.0 - 01/12/2025 12:40 - Conversoes: Base 10 para Bin, Hex e BCD
# Rev 3.0 - 01/12/2025 13:45 - Complemento a 2 (16 bits)

.data
    menu_msg:   .asciiz "\nCALCULADORA DIDATICA MIPS\n1. Base 10 para Bin, Oct, Hex, BCD\n2. Compl. a 2 (16 bits)\n3. Float/Double (IEEE 754)\n0. Sair\nEscolha: "
    bye_msg:    .asciiz "\nEncerrando."
    invalid_msg:.asciiz "\nOpcao invalida!"
    
    # Strings da Parte 2 (Conversoes)
    msg_int:    .asciiz "\nDigite um inteiro (Base 10): "
    msg_bin:    .asciiz "\na) Base 2 (Binario): "
    msg_oct:    .asciiz "\nb) Base 8 (Octal - Aprox via Hex): "
    msg_hex:    .asciiz "\nc) Base 16 (Hexadecimal): "
    msg_bcd:    .asciiz "\nd) BCD (Digitos Decimais): "

    # Strings da Parte 3 (Complemento a 2)
    msg_orig:   .asciiz "\n1. Original (16 bits Hex): "
    msg_not:    .asciiz "\n2. Apos NOT (Inversao):    "
    msg_c2:     .asciiz "\n3. Apos Soma 1 (Final):    "
    
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

# FUNCAO 2: COMPLEMENTO A 2 (IMPLEMENTADO NA REV 3.0)
compl_two:
    # 1. Pedir numero
    li $v0, 4
    la $a0, msg_int
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Mascara para garantir apenas 16 bits (0xFFFF)
    andi $t0, $t0, 0xFFFF
    
    # Passo 1: Mostrar Original
    li $v0, 4
    la $a0, msg_orig
    syscall
    
    li $v0, 34      # Syscall 34 imprime em Hex
    move $a0, $t0
    syscall
    
    # Passo 2: Inverter Bits (NOT)
    not $t1, $t0          # $t1 recebe o inverso de $t0
    andi $t1, $t1, 0xFFFF # Mascara visual novamente (limpa bits superiores)
    
    li $v0, 4
    la $a0, msg_not
    syscall
    
    li $v0, 34
    move $a0, $t1
    syscall
    
    # Passo 3: Somar 1 (Complemento a 2)
    add $t1, $t1, 1
    andi $t1, $t1, 0xFFFF # Mascara final
    
    li $v0, 4
    la $a0, msg_c2
    syscall
    
    li $v0, 34
    move $a0, $t1
    syscall

    j main

# Stub Final
float_double:
    j main

exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10
    syscall