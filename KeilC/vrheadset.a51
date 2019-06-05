//TanSoVDK=TanSoThachAnh/12=12/12=1 (Mhz) = 1 000 000 (Hz)
//ChuKiTimer=(1/1 000 000) (s)
//TanSoVDK/32=31250 (Hz)
//So can nap vo TH1: (31250/9600)*-1 = -3,2
//Cong thuc tinh sai so: (so thap phan - phan nguyen)/(phan nguyen) * 100
//(3.2-3)/3 *100 = 6,6% > 5%-> khong dung baud rate 9600 vs thach anh 12 Mhz duoc

org   0000h
jmp   main

org 0023h ;jump here when interrupt 8051 receives data (RI=1)
mov R7,#0
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
		
;------
//Loop:	
		//ACALL MOVE90 //servo duoi: quay len tren
		//ACALL DELAYSV
		//ACALL MOVE45
		//ACALL DELAYSV
		//ACALL MOVE0
		//ACALL DELAYSV
		//ACALL MOVET45
		//ACALL DELAYSV
		//ACALL MOVET90//servo duoi: quay xuong duoi
		//ACALL DELAYSV
      //jmp Loop
	  /*
	  servo1: ground-sky: Pwm on P2.0 //tiankon
	  -quay len tren: 1 - move90
	  -quay xuong duoi: 5- movet90
	  servo2: left-right: Pwm on P2.1 //tower pro
	  -quay sang trai: 1 - movet90
	  -quay sang phai: 5 - move90
	  
	  */
;-----
		
serial:
		mov R7,SBUF
		;mov R7,A
		acall control_servo
		clr RI
		acall reply
		reti

control_servo:
		cjne R7,#'a',pass1 ;if R7 != a then jump to pass1//11
		acall MOVE90_servo1 ;function for servo1
		acall MOVET90_servo2 ;function for servo2
		ret ;return to serial function
		
pass1:	cjne R7,#'b',pass2 ;if R7 != b then jump to pass2//12
		acall MOVE90_servo1
		acall MOVET45_servo2 ;function for servo2
		ret
pass2:	cjne R7,#'c',pass3 ;if R7 != b then jump to pass2//13
		acall MOVE90_servo1
		acall MOVE0_servo2 ;function for servo2
		ret
pass3:	cjne R7,#'d',pass4 ;if R7 != b then jump to pass2//14
		acall MOVE90_servo1
		acall MOVE45_servo2 ;function for servo2
		ret
pass4:	cjne R7,#'e',pass5 ;if R7 != b then jump to pass2//15
		acall MOVE90_servo1
		acall MOVE90_servo2 ;function for servo2
		ret
pass5:	cjne R7,#'f',pass6 ;if R7 != b then jump to pass2//21
		acall MOVE45_servo1
		acall MOVET90_servo2 ;function for servo2
		ret
pass6:	cjne R7,#'g',pass7 ;if R7 != b then jump to pass2//22
		acall MOVE45_servo1
		acall MOVET45_servo2 ;function for servo2
		ret
pass7:	cjne R7,#'h',pass8 ;if R7 != b then jump to pass2//23
		acall MOVE45_servo1
		acall MOVE0_servo2 ;function for servo2
		ret
pass8:	cjne R7,#'i',pass9 ;if R7 != b then jump to pass2//24
		acall MOVE45_servo1
		acall MOVE45_servo2 ;function for servo2
		ret
pass9:	cjne R7,#'j',pass10 ;if R7 != b then jump to pass2//25
		acall MOVE45_servo1
		acall MOVE90_servo2 ;function for servo2
		ret
pass10:	cjne R7,#'k',pass11 ;if R7 != b then jump to pass2//31
		acall MOVE0_servo1
		acall MOVET90_servo2 ;function for servo2
		ret
pass11:	cjne R7,#'l',pass12 ;if R7 != b then jump to pass2//32
		acall MOVE0_servo1
		acall MOVET45_servo2 ;function for servo2
		ret
pass12:	cjne R7,#'m',pass13 ;if R7 != b then jump to pass2//33
		acall MOVE0_servo1
		acall MOVE0_servo2 ;function for servo2
		ret
pass13:	cjne R7,#'n',pass14 ;if R7 != b then jump to pass2//34
		acall MOVE0_servo1
		acall MOVE45_servo2 ;function for servo2
		ret
pass14:	cjne R7,#'o',pass15 ;if R7 != b then jump to pass2//35
		acall MOVE0_servo1
		acall MOVE90_servo2 ;function for servo2
		ret
pass15:	cjne R7,#'p',pass16 ;if R7 != b then jump to pass2//41
		acall MOVET45_servo1
		acall MOVET90_servo2 ;function for servo2
		ret
pass16:	cjne R7,#'q',pass17 ;if R7 != b then jump to pass2//42
		acall MOVET45_servo1
		acall MOVET45_servo2 ;function for servo2
		ret
pass17:	cjne R7,#'r',pass18 ;if R7 != b then jump to pass2//43
		acall MOVET45_servo1
		acall MOVE0_servo2 ;function for servo2
		ret
pass18:	cjne R7,#'s',pass19 ;if R7 != b then jump to pass2//44
		acall MOVET45_servo1
		acall MOVE45_servo2 ;function for servo2
		ret
pass19:	cjne R7,#'t',pass20 ;if R7 != b then jump to pass2//45
		acall MOVET45_servo1
		acall MOVE90_servo2 ;function for servo2
		ret
pass20:	cjne R7,#'u',pass21 ;if R7 != b then jump to pass2//51
		acall MOVET90_servo1
		acall MOVET90_servo2 ;function for servo2
		ret		
pass21:	cjne R7,#'v',pass22 ;if R7 != b then jump to pass2//52
		acall MOVET90_servo1
		acall MOVET45_servo2 ;function for servo2
		ret
pass22:	cjne R7,#'w',pass23 ;if R7 != b then jump to pass2//53
		acall MOVET90_servo1
		acall MOVE0_servo2 ;function for servo2
		ret
pass23:	cjne R7,#'x',pass24 ;if R7 != b then jump to pass2//54
		acall MOVET90_servo1
		acall MOVE45_servo2 ;function for servo2
		ret
pass24:	cjne R7,#'y',pass25 ;if R7 != b then jump to pass2//55
		acall MOVET90_servo1
		acall MOVE90_servo2 ;function for servo2
		ret		
pass25:	ret

reply:
		mov A,#'z'
		mov sbuf,A
		back:jnb TI,back
		clr TI
		ret

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
;------------------------------	CHUONG TRINH CON GOC SERVO 1 -------------------
MOVE90_servo1:
	MOV R7,#20
MOVE900_servo1:
	SETB P2.0
	CALL DELAY90
	CLR P2.0
	CALL DELAY90
	DJNZ R7,MOVE900_servo1
	MOV R7,#0
	RET

MOVE45_servo1:
	MOV R7,#20
MOVE455_servo1:
	SETB P2.0
	CALL DELAY45
	CLR P2.0
	CALL DELAY45
	DJNZ R7,MOVE455_servo1
	MOV R7,#0
	RET

MOVE0_servo1:
	MOV R7,#20
MOVE00_servo1:
	SETB P2.0
	CALL DELAY0
	CLR P2.0
	CALL DELAY0
	DJNZ R7,MOVE00_servo1
	MOV R7,#0
	RET

MOVET45_servo1:
	MOV R7,#20
MOVET455_servo1:
	SETB P2.0
	CALL DELAYT45
	CLR P2.0
	CALL DELAYT45
	DJNZ R7,MOVET455_servo1
	MOV R7,#0
	RET
	
MOVET90_servo1:
	MOV R7,#20
MOVET900_servo1:
	SETB P2.0
	CALL DELAYT90
	CLR P2.0
	CALL DELAYT90
	DJNZ R7,MOVET900_servo1
	MOV R7,#0
	RET
	
;------------------------------	CHUONG TRINH CON GOC SERVO 2 -------------------
MOVE90_servo2:
	MOV R7,#20
MOVE900_servo2:
	SETB P2.1
	CALL DELAY90
	CLR P2.1
	CALL DELAY90
	DJNZ R7,MOVE900_servo2
	MOV R7,#0
	RET

MOVE45_servo2:
	MOV R7,#20
MOVE455_servo2:
	SETB P2.1
	CALL DELAY45
	CLR P2.1
	CALL DELAY45
	DJNZ R7,MOVE455_servo2
	MOV R7,#0
	RET

MOVE0_servo2:
	MOV R7,#20
MOVE00_servo2:
	SETB P2.1
	CALL DELAY0
	CLR P2.1
	CALL DELAY0
	DJNZ R7,MOVE00_servo2
	MOV R7,#0
	RET

MOVET45_servo2:
	MOV R7,#20
MOVET455_servo2:
	SETB P2.1
	CALL DELAYT45
	CLR P2.1
	CALL DELAYT45
	DJNZ R7,MOVET455_servo2
	MOV R7,#0
	RET
	
MOVET90_servo2:
	MOV R7,#20
MOVET900_servo2:
	SETB P2.1
	CALL DELAYT90
	CLR P2.1
	CALL DELAYT90
	DJNZ R7,MOVET900_servo2
	MOV R7,#0
	RET
	
;-----------	
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