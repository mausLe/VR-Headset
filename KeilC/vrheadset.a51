//TanSoVDK=TanSoThachAnh/12=12/12=1 (Mhz) = 1 000 000 (Hz)
//ChuKiTimer=1/1 000 000 (s)

ORG   0000H      
      JMP   MAIN

ORG 0030H
MAIN:
      MOV TMOD, #01 ;timer0,mode1, 0-65535
      acall Goc_am90  
	  acall delay
	  acall Goc_90
	  acall delay
      JMP MAIN
	  
Goc_am90:
	ACALL SET_DUTYCYCLE1_am90 //1
	ACALL SET_DUTYCYCLE0_am90 //20
	ret //(1/20)~0,05~(-90)(do)

Goc_90:
	ACALL SET_DUTYCYCLE1_90 //1.5
    ACALL SET_DUTYCYCLE0_90 //20
    ret   //(1.5/20)~0,075~90(do)

SET_DUTYCYCLE0_am90:
//Can dat: 20(ms) - 1(ms)=19(ms)
//19/1000 = Tongthoigian(xungthap)
//Solandem=0,019/(1/1000 000)=19 000 (lan)->Dem tu 65536-19 000= 46 536=0xB5C8
      clr P2.0
      MOV TH0,#HIGH(0B5C8h)
      MOV TL0,#LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
      
SET_DUTYCYCLE1_am90:
//Can dat: 1(ms)
//1/1000 = Tongthoigian(xungcao)
//Solandem=0,001/(1/1000 000)=1000 (lan)->Dem tu 65536-1000= 64 536=0xFC18
      SETB P2.0
      MOV TH0,#HIGH(0FC18h)
      MOV TL0,#LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
      

	  
SET_DUTYCYCLE0_90:
//Can dat: 20(ms) - 1.5(ms)=18.5(ms)
//18.5/1000 = Tongthoigian(xungthap)
//Solandem=0,0185/(1/1000 000)=18 500 (lan)->Dem tu 65536-18 500= 47 036=0xB7BC
      clr P2.0
      MOV TH0,#HIGH(0B7BCh)
      MOV TL0,#LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
	 
SET_DUTYCYCLE1_90:
//Can dat: 1,5(ms)
//1,5/1000 = Tongthoigian(xungcao)
//Solandem=0,0015/(1/1000 000)=1500 (lan)->Dem tu 65536-1500= 64 036=0xFA24
      SETB P2.0
      MOV TL0, #HIGH(0FA24h)
      MOV TH0, #LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
      
DELAY: MOV R1, #255;Delay is 200ms
      L0: MOV R2, #255
	 L1: MOV R3, #25
	    L2: DJNZ R3, L2
	 DJNZ R2, L1
      DJNZ R1, L0
      RET
	 
END