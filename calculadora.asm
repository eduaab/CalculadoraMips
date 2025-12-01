# Autor: Eduardo Albuquerque Alves Barbosa
# Data: 01/12/2025

# Rev 1.0 - 01/12/2025 12:13 - Estrutura inicial e Menu Principal
# Rev 2.0 - 01/12/2025 12:40 - Conversoes: Base 10 para Bin, Hex e BCD
# Rev 3.0 - 01/12/2025 13:45 - Complemento a 2 (16 bits)
# Rev 4.0 - 01/12/2025 14:10 - Ponto Flutuante (IEEE 754)

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
    
    # Strings da Parte 4 (Ponto Flutuante)
    msg_float:   .asciiz "\nDigite um numero Real (ex: 12.5): "
    msg_title_f: .asciiz "\nAnalise FLOAT (32 bits)"
    msg_title_d: .asciiz "\nAnalise DOUBLE (64 bits - Parte Alta)"
    msg_sign:    .asciiz "\nSinal (0=+, 1=-): "
    msg_exp:     .asciiz "\nExpoente (Raw): "
    msg_bias:    .asciiz " (Com vies removido: "
    msg_mant:    .asciiz ")\nMantissa (Hex): "
    close_par:   .asciiz ")"

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

# FUNCAO 1: CONVERSAO DE BASES
conv_bases:
    li $v0, 4
    la $a0, msg_int
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    # Binario
    li $v0, 4
    la $a0, msg_bin
    syscall
    li $v0, 35
    move $a0, $t0
    syscall

    # Octal
    li $v0, 4
    la $a0, msg_oct
    syscall
    li $v0, 34
    move $a0, $t0
    syscall

    # Hexa
    li $v0, 4
    la $a0, msg_hex
    syscall
    li $v0, 34
    move $a0, $t0
    syscall
    
    # BCD
    li $v0, 4
    la $a0, msg_bcd
    syscall
    li $v0, 1
    move $a0, $t0
    syscall

    j main

# FUNCAO 2: COMPLEMENTO A 2
compl_two:
    li $v0, 4
    la $a0, msg_int
    syscall
    
    li $v0, 5
    syscall
    move $t0, $v0
    
    andi $t0, $t0, 0xFFFF
    
    # Passo 1
    li $v0, 4
    la $a0, msg_orig
    syscall
    li $v0, 34
    move $a0, $t0
    syscall
    
    # Passo 2
    not $t1, $t0
    andi $t1, $t1, 0xFFFF
    li $v0, 4
    la $a0, msg_not
    syscall
    li $v0, 34
    move $a0, $t1
    syscall
    
    # Passo 3
    add $t1, $t1, 1
    andi $t1, $t1, 0xFFFF
    li $v0, 4
    la $a0, msg_c2
    syscall
    li $v0, 34
    move $a0, $t1
    syscall

    j main

# FUNCAO 3: PONTO FLUTUANTE (IMPLEMENTADO NA REV 4.0)
float_double:
    # 1. Ler Float
    li $v0, 4
    la $a0, msg_float
    syscall
    
    li $v0, 6            # Syscall 6 le float e coloca em $f0
    syscall
    
    # Move bits de $f0 para registro inteiro $t0 para manipular
    mfc1 $t0, $f0
    
    # === ANALISE FLOAT (32 bits) ===
    li $v0, 4
    la $a0, msg_title_f
    syscall

    # Sinal (Bit 31)
    srl $t1, $t0, 31     # Desloca tudo pra direita, sobra o bit 31
    li $v0, 4
    la $a0, msg_sign
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Expoente (Bits 23-30) - 8 bits
    sll $t1, $t0, 1      # Remove sinal
    srl $t1, $t1, 24     # Coloca expoente no inicio
    
    li $v0, 4
    la $a0, msg_exp
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Vies (Bias 127 para float)
    li $v0, 4
    la $a0, msg_bias
    syscall
    sub $t1, $t1, 127
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, close_par
    syscall

    # Mantissa (Bits 0-22)
    li $v0, 4
    la $a0, msg_mant
    syscall
    andi $t1, $t0, 0x007FFFFF # Mascara mantem so os 23 bits baixos
    li $v0, 34           # Print Hex
    move $a0, $t1
    syscall

    # === ANALISE DOUBLE (64 bits) ===
    # Convertemos o float de entrada para double ($f2, $f3)
    cvt.d.s $f2, $f0
    
    li $v0, 4
    la $a0, msg_title_d
    syscall
    
    # No MIPS (MARS), a parte alta (Sinal + Exp) do double fica no reg impar ($f3)
    mfc1 $t2, $f3        
    
    # Sinal (Bit 31 da word alta)
    srl $t1, $t2, 31
    li $v0, 4
    la $a0, msg_sign
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Expoente (11 bits: 20-30 da word alta)
    sll $t1, $t2, 1      # Remove sinal
    srl $t1, $t1, 21     # Sobram 11 bits
    
    li $v0, 4
    la $a0, msg_exp
    syscall
    li $v0, 1
    move $a0, $t1
    syscall
    
    # Vies (Bias 1023 para double)
    li $v0, 4
    la $a0, msg_bias
    syscall
    sub $t1, $t1, 1023
    li $v0, 1
    move $a0, $t1
    syscall
    li $v0, 4
    la $a0, close_par
    syscall
    
    # Mantissa (Hexa parcial da parte alta)
    li $v0, 4
    la $a0, msg_mant
    syscall
    andi $t1, $t2, 0x000FFFFF # Mascara mantissa alta
    li $v0, 34
    move $a0, $t1
    syscall

    j main

exit_prog:
    li $v0, 4
    la $a0, bye_msg
    syscall
    
    li $v0, 10
    syscall
