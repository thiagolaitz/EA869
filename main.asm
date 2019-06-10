;
; EEPROM_Ready.asm
;
; Created: 08/06/2019 20:50:03
; Author : Thiago Soares Laitz - 224898
;		   Gabriel Araujo Pinheiro - 216073

;Endere�o inicial da EEPROM
.equ END_EEPROM = 0x0000

.cseg
	;a partir de 0x00, temos o vetor de interrup��o
	.org 0x0000
	rjmp reset
	;endere�o do vetor de interrup��o para o EEMPROM_READY
	.org 0x002C
	rjmp EEPROM_READY
	;Fim do vetor de interrup��o
	.org 0x0034				

dados: .db 5, 0x86,0x73,0xa4,0x5b,0x19

reset:
	;Guarda o endere�o de acesso inicial � EEPROM
	ldi r27,high(END_EEPROM)
	ldi r26,low(END_EEPROM)
	
	;Endere�o inicial de acesso � mem�ria de programa
	ldi ZH,high(dados*2)
	ldi ZL,low(dados*2)

	;carrega em r1 o valor do n�mero de bytes que vamos escrever e atualiza o endere�o de acesso
	lpm r1,Z+
	;zera o contador de bytes utilizados
	clr r2
	;Seta Global Flag Interrupt
	sei
	;Ativa a flag EERIE respons�vel pela interrup��o EEPROM READY
	sbi EECR, EERIE

main:;finalizar� o programa quando todos os dados forem escritos na EEPROM
	cp r2,r1
	breq fim
	rjmp main

EEPROM_READY: 
	;rotina de escrita na EEPROM
	;Endere�o de onde vou escrever na EEPROM
	out EEARH,r27
	out EEARL,r26
	
	;Salvo o byte de dados no registrador r0 atrav�s de um endere�amento indireto na mem�ria
	lpm r0,Z+
	;Salva em r3 apenas para fazer um p�s incremento no registrador X
	ld r3, X+
	;Salvo no registrador de dados da EEPROM para a escrita
	out EEDR,r0
	;Controle
	sbi EECR,2
	sbi EECR,1
	;incremento o meu registrador contador
	inc r2
	;retorna da subrotina de interrup��o
	reti

fim:;Desabilita a interrup��o da EEPROM e finaliza o programa
	cbi EECR, EERIE
	break