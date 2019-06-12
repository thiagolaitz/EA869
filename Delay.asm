; delay.asm
;
; Created: 11/06/2019 08:49:03
; Author : Thiago Soares Laitz
;
.equ parametro = 0x1900 ;0x1900 = 0,1s // 0xFA00 = 1s (6400 / 64000)
;utilizamos: R19,R27,R26,R17,R1,r20
.cseg

;A partir desde ponto podemos transformar em uma subrotina.
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
break
