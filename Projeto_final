; Projeto_final.asm
;
; Created: 15/06/2019 20:01:47
; Author :  Thiago Soares Laitz - 224898
;			Gabriel Araujo Pinheiro - 216073			
;			Gabriel Dante Roque

;programa MAIN: pisca pisca

;DELAY: 0x1900 = 0,1s // 0xFA00 = 1s // 0x7D00 = 0,5s // 0x3E80 = 0,25s ===> 64000x = 1s
;utilizamos: R19,R27,R26,R17,R1,r20

.cseg
	;a partir de 0x00, temos o vetor de interrupção
	.org 0x0000
	rjmp reset
	;endereço do vetor de interrupção para o int0
	.org 0x0002
	rjmp parametro
	;Fim do vetor de interrupção
	.org 0x0034		

reset:
	ldi r27,0xFA ;configurações iniciais para piscar a cada 1s
	ldi r26,0x00
	ldi r2, 0
	; seta os dois bits menos significativos para ativar a interrupção em borda de subida 
	lds r16,EICRA
	ori r16,0x03
	sts EICRA,r16

	;habilita a interrupção INT0
	in r16,EIMSK
	ori r16,0x01
	out EIMSK,r16

	;habilita todas as interrupções
	sei					
		
main:;rotina que deve piscar o LED
	
	rjmp main

parametro:;a ideia é usar um registrador para saber em qual estado ele está, r2 = 0 (1s), r2 = 1 (0,5s), r2 = 2 (0,25s)
	cpi r2,0
	breq meio
	cpi r2,1
	breq um_quarto
	cpi r2,2
	breq um
	meio:;seta os parametros para um delay de 0,5s e atualiza o registrador auxiliar
		ldi r27,0x7D
		ldi r26,0x00
		ldi r2, 1
		rjmp main
	um_quarto:;seta os parametros para um delay de 0,25s e atualiza o registrador auxiliar
		ldi r27,0x3E
		ldi r26,0x80
		ldi r2, 2
		rjmp main
	um:;seta os parametros para um delay de 1s e atualiza o registrador auxiliar
		ldi r27,0xFA
		ldi r26,0x00
		ldi r2, 0
		rjmp main

delay:
	;o primeiro passo é configurar o parâmetro com 16 bits; 6400x = 0,1s , 64000x = 1s
	ldi r27, high(parametro)
	ldi r26, low(parametro)
	ldi r19, 0
	ldi r20, 24

	loop:; esta rotina deve ter exatamente 250 ciclos
	ldi r17,0
	or r17,r27
	or r17,r26;o único caso positivo é quando r26 = r27 = 0
	cpi r17,0
	breq fim
	nop
	nop
	ld r1, -X
	ldi r18, 47

	loop_int:;deve consumir exatamente 240 ciclos
		cpi r18,0
		breq fora
		dec r18
		rjmp loop_int
	
	fora:
	rjmp loop

	fim:;acrescentar RET para voltar da subrotina no projeto final
	ret
