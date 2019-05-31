//TanSoVDK=TanSoThachAnh/12=12/12=1 (Mhz) = 1 000 000 (Hz)
//ChuKiTimer=(1/1 000 000) (s)
//TanSoVDK/32=31250 (Hz)
//So can nap vo TH1: (31250/9600)*-1 = -3,2
//Cong thuc tinh sai so: (so thap phan - phan nguyen)/(phan nguyen) * 100
//(3.2-3)/3 *100 = 6,6% > 5%-> khong dung baud rate 9600 vs thach anh 12 Mhz duoc

org   0000h
jmp   main

org 0023h ;jump here when interrupt 8051 receives data (RI=1)
ljmp serial

;====================================================================
; CODE SEGMENT
;====================================================================

      org   0030h
main:	
		MOV TMOD, #00100001b
		;timer0,mode1, 0-65535 for control servo
		;timer1,mode2 0-255 auto reload for uart
		mov TH1,#0f3h ;baud rate 2400 with smod=0 and F_thachanh=12 Mhz //#0f3h
		mov SCON,#50h ;usually like this value
		mov IE,#10010000b ;enable serial interrupt and disable other interrupts
		setb TR1 ;enable timer1 of uart
		here: sjmp here ;loop here waiting for uart transmit to
		JMP MAIN      
		
serial:
		mov R7,SBUF
		;mov R7,A
		acall control_servo
		clr RI
		reti

control_servo:
		cjne R7,#'a',pass1 ;if R7 != a then jump to pass1
		acall MOVE90 ;function for servo1
		;acall Goc_45 ;function for servo2
		ret ;return to serial function
		
pass1:	cjne R7,#'b',pass2 ;if R7 != b then jump to pass2
		acall MOVET90
		ret
		
pass2:	cjne R7,#90,pass3
		;acall Goc_90
pass3:	ret


;------
//Loop:	
		//ACALL MOVE90
		//ACALL DELAYSV
		//ACALL MOVE45
		//ACALL DELAYSV
		//ACALL MOVE0
		//ACALL DELAYSV
		//ACALL MOVET45
		//ACALL DELAYSV
		//ACALL MOVET90
		//ACALL DELAYSV
      //jmp Loop
;-----

DELAYSV:
	MOV	R7,#5
	DELAYSVV:
	MOV TL0,#LOW(-60000)
	MOV TH0,#HIGH(-60000)
	SETB	TR0
	AGAIN:	JNB	TF0,	AGAIN
	CLR	TR0
	CLR	TF0
	DJNZ R7,DELAYSVV
	MOV	R7,#0
	RET
;------------------------------	CHUONG TRINH CON GOC SERVO -------------------
MOVE90:
	MOV R7,#20
MOVE900:
	SETB P2.0
	CALL DELAY90
	CLR P2.0
	CALL DELAY90
	DJNZ R7,MOVE900
	MOV R7,#0
	RET

MOVE45:
	MOV R7,#20
MOVE455:
	SETB P2.0
	CALL DELAY45
	CLR P2.0
	CALL DELAY45
	DJNZ R7,MOVE455
	MOV R7,#0
	RET

MOVE0:
	MOV R7,#20
MOVE00:
	SETB P2.0
	CALL DELAY0
	CLR P2.0
	CALL DELAY0
	DJNZ R7,MOVE00
	MOV R7,#0
	RET

MOVET45:
	MOV R7,#20
MOVET455:
	SETB P2.0
	CALL DELAYT45
	CLR P2.0
	CALL DELAYT45
	DJNZ R7,MOVET455
	MOV R7,#0
	RET
MOVET90:
	MOV R7,#20
MOVET900:
	SETB P2.0
	CALL DELAYT90
	CLR P2.0
	CALL DELAYT90
	DJNZ R7,MOVET900
	MOV R7,#0
	RET
		
DELAY90:
	MOV TL0,#LOW(-2500)
	MOV TH0,#HIGH(-2500)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAY45:
	MOV TL0,#LOW(-2000)
	MOV TH0,#HIGH(-2000)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAY0:
	MOV TL0,#LOW(-1500)
	MOV TH0,#HIGH(-1500)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
DELAYT45:
	MOV TL0,#LOW(-1000)
	MOV TH0,#HIGH(-1000)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET	
DELAYT90:
	MOV TL0,#LOW(-500)
	MOV TH0,#HIGH(-500)
	SETB TR0
	JNB  TF0,$
	CLR  TR0
	CLR  TF0
	RET
end