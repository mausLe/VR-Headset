	  ORG   0000H      
      JMP   MAIN

      ORG 0030H
MAIN:
      MOV TMOD, #01H
      
      ;SETB P2.2
            
   BEGIN:
      ACALL SET_DUTYCYCLE1
      ACALL DELAY
      ACALL SET_DUTYCYCLE0
      ACALL DELAY

      ACALL SET_DUTYCYCLE2
      ACALL DELAY
      ACALL SET_DUTYCYCLE0
      ACALL DELAY      
      ;ACALL SET_DUTYCYCLE3
      ;ACALL DELAY
      
      SJMP MAIN
   SET_DUTYCYCLE0:
   SETB P2.0
      MOV TH0,#HIGH(1480)
      MOV TL0,#LOW(1480)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      
      CPL P2.0
      RET
      
   SET_DUTYCYCLE1:
   SETB P2.0
      MOV TH0,#HIGH(-950)
      MOV TL0,#LOW(-950)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      
      CPL P2.0
      RET
      
   SET_DUTYCYCLE2:
   SETB P2.0
      MOV TL0, #HIGH(-2000)
      MOV TH0, #LOW(-2000)
      SETB TR0
      JNB TF0, $
      CLR TR0
      CLR TF0
      
      CPL P2.0
      RET
      
   DELAY: MOV R1, #200;Delay is 200ms
      L0: MOV R2, #40
	 L1: MOV R3, #25
	    L2: DJNZ R3, L2
	 DJNZ R2, L1
      DJNZ R1, L0
      RET
	 
END