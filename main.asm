;
; EEPROM_Ready.asm
;
; Created: 08/06/2019 20:50:03
; Author : Thiago Soares Laitz - 224898
;		   Gabriel Araujo Pinheiro - 216073

;Endereço inicial da EEPROM
.equ END_EEPROM = 0x0000

.cseg
	;a partir de 0x00, temos o vetor de interrupção
	.org 0x0000
	rjmp reset
	;endereço do vetor de interrupção para o EEMPROM_READY
	.org 0x002C
	rjmp EEPROM_READY
	;Fim do vetor de interrupção
	.org 0x0034				

dados: .db 5, 0x86,0x73,0xa4,0x5b,0x19

reset:
	;Guarda o endereço de acesso inicial à EEPROM
	ldi r27,high(END_EEPROM)
	ldi r26,low(END_EEPROM)
	
	;Endereço inicial de acesso à memória de programa
	ldi ZH,high(dados*2)
	ldi ZL,low(dados*2)

	;carrega em r1 o valor do número de bytes que vamos escrever e atualiza o endereço de acesso
	lpm r1,Z+
	;zera o contador de bytes utilizados
	clr r2
	;Seta Global Flag Interrupt
	sei
	;Ativa a flag EERIE responsável pela interrupção EEPROM READY
	sbi EECR, EERIE

main:;finalizará o programa quando todos os dados forem escritos na EEPROM
	cp r2,r1
	breq fim
	rjmp main

EEPROM_READY: 
	;rotina de escrita na EEPROM
	;Endereço de onde vou escrever na EEPROM
	out EEARH,r27
	out EEARL,r26
	
	;Salvo o byte de dados no registrador r0 através de um endereçamento indireto na memória
	lpm r0,Z+
	;Salva em r3 apenas para fazer um pós incremento no registrador X
	ld r3, X+
	;Salvo no registrador de dados da EEPROM para a escrita
	out EEDR,r0
	;Controle
	sbi EECR,2
	sbi EECR,1
	;incremento o meu registrador contador
	inc r2
	;retorna da subrotina de interrupção
	reti

fim:;Desabilita a interrupção da EEPROM e finaliza o programa
	cbi EECR, EERIE
	break