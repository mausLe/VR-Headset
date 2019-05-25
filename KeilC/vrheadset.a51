//TanSoVDK=TanSoThachAnh/12=12/12=1 (Mhz) = 1 000 000 (Hz)
//ChuKiTimer=1/1 000 000 (s)

ORG   0000H      
      JMP   MAIN

ORG 0030H
MAIN:
      MOV TMOD, #01 ;timer0,mode1, 0-65535
      acall Goc_am90  ;64536 -46536 (1-0) / sum = 111 072
	  //acall Goc_0 		;64036 - 47036 (1-0) (0FA24h - 0B7BCh)
	  //tested:63800 of Goc_0 - no hope!
	  //acall Goc_duong90 ;63536 - 47536 (1-0)
	  
      JMP MAIN
	  
Goc_am90: ;----------------------------------------------------------------
	ACALL SET_DUTYCYCLE1_am90 //1
	ACALL SET_DUTYCYCLE0_am90 //19
	ret //(1/19)~0,05~(-90)(do)
	
SET_DUTYCYCLE0_am90:
//Can dat: 20(ms) - 1(ms)=19(ms)
//19/1000 = Tongthoigian(xungthap)
//Solandem=0,019/(1/1000 000)=19 000 (lan)->Dem tu 65536-19 000= 46 536=0xB5C8
      clr P2.0
      MOV TH0,#HIGH(0B5h)
      MOV TL0,#LOW(0C8h)
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
      MOV TH0,#HIGH(0FCh)
      MOV TL0,#LOW(018h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET

Goc_0:;-----------------------------------------
	lCALL SET_DUTYCYCLE1_0 //1.5
    lCALL SET_DUTYCYCLE0_0 //18.5
    ret   //(1.5/18.5)~0,075~90(do)
  
SET_DUTYCYCLE0_0:
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
	 
SET_DUTYCYCLE1_0:
//Can dat: 1,5(ms)
//1,5/1000 = Tongthoigian(xungcao)
//Solandem=0,0015/(1/1000 000)=1500 (lan)->Dem tu 65536-1500= 64 036=0xFA24
      SETB P2.0
      MOV TH0, #HIGH(0FA24h)
      MOV TL0, #LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
      
Goc_duong90:;-----------------------------------------
	lCALL SET_DUTYCYCLE1_duong90 
    lCALL SET_DUTYCYCLE0_duong90 
    ret   
  
SET_DUTYCYCLE0_duong90:
//Can dat: 20(ms) - 2(ms)=18(ms)
//18/1000 = Tongthoigian(xungthap)
//Solandem=0,018/(1/1000 000)=18 000 (lan)->Dem tu 65536-18 000= 47 536=0xB9B0
      clr P2.0
      MOV TH0,#HIGH(0B9B0h)
      MOV TL0,#LOW(0h)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      RET
	 
SET_DUTYCYCLE1_duong90:
//Can dat: 2(ms)
//2/1000 = Tongthoigian(xungcao)
//Solandem=0,002/(1/1000 000)=2000 (lan)->Dem tu 65536-2000= 63 536=0xF830
      SETB P2.0
      MOV TH0, #HIGH(0F830h)
      MOV TL0, #LOW(0h)
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