;
; Exercicio_AMI.asm
;
; Created: 19/05/2019 11:23:23
; Author : Thiago Soares Laitz     224898
;	   Gabriel Araújo Pinheiro 216073

.dseg;reserva bytes na memoria de dados
codigo: .byte 24; colocar um valor P = 8N

.cseg
vetor: .db 3, 0x86, 0x73, 0xa4 ;Colocar aqui a sequência de dados a se testar.

.org 0x0200
ldi r30, 0x00
ldi r31, 0x00; carrega no registrador Z o endereço dos dados
ldi r27, 0x03; escolho o local de armazenamento do resultado codificado
ldi r26, 0x00

lpm r20, z+; a partir deste valor, pegamos a quantidade de bytes de informação.
/*O registrador r21 funcionará como um registrador contador, para realizar o desvio
quando já resgatarmos todos os bytes*/
ldi r21, 0

loop:;loop até que todos os bytes sejam analisados
	ldi r24,0
	cp r20,r21
	breq fim
	inc r21; incrementa o contador
	lpm r17,z+; carrega em r17 o primeiro byte a analisar e incrementa RZ
	rjmp analise

;Registrador r18 será usado para controlar se devemos colocar +1 ou -1
analise:; sequência inicial de bits : ABCDEFGH. Ideia: shift e analisar flag C
	cpi r24,8 ;verifica quantas vezes foi rodado "analise": usando o registrador r24
	breq loop
	inc r24
	lsl r17;logical shift left
	brcs ami; desvia se a flag C == 1
	ldi r19,0 ;se for zero => r19 == 0
	rjmp escrever

ami:;usar r19 para salvar a codificação do bit: se r18 == 1 (último valor alto foi +1) se r18 == 0 (último = -1).
	cpi r18, 1
	breq negativo
	ldi r19, 1
	ldi r18, 1
	rjmp escrever

negativo:;caso o ultimo bit foi positivo => próximo negativo
	ldi r19, -1
	ldi r18, 0 
	rjmp escrever

escrever:;escreve na memoria de dados o valor de r19 
	st x+ , r19
	rjmp analise
	
fim:
	break

