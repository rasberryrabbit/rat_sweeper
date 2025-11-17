
_Interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Sweep_12F683.mpas,15 :: 		begin
;Sweep_12F683.mpas,16 :: 		if T1IF_bit=1 then begin
	BTFSS      T1IF_bit+0, BitPos(T1IF_bit+0)
	GOTO       L__Interrupt2
;Sweep_12F683.mpas,17 :: 		TMR1H:=TMR1H_LOAD;
	MOVLW      158
	MOVWF      TMR1H+0
;Sweep_12F683.mpas,18 :: 		TMR1L:=TMR1L_LOAD;
	MOVLW      87
	MOVWF      TMR1L+0
;Sweep_12F683.mpas,19 :: 		T1IF_bit:=0;
	BCF        T1IF_bit+0, BitPos(T1IF_bit+0)
;Sweep_12F683.mpas,20 :: 		Inc(TICK_100);
	INCF       _TICK_100+0, 1
;Sweep_12F683.mpas,21 :: 		end;
L__Interrupt2:
;Sweep_12F683.mpas,22 :: 		end;
L_end_Interrupt:
L__Interrupt27:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _Interrupt

_TickDiff:

;Sweep_12F683.mpas,27 :: 		begin
;Sweep_12F683.mpas,28 :: 		if cur<pre then
	MOVF       FARG_TickDiff_pre+0, 0
	SUBWF      FARG_TickDiff_cur+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L__TickDiff6
;Sweep_12F683.mpas,29 :: 		diff:=cur+(255-pre)+1
	MOVF       FARG_TickDiff_pre+0, 0
	SUBLW      255
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDWF      FARG_TickDiff_cur+0, 0
	MOVWF      R2+0
	INCF       R2+0, 1
	GOTO       L__TickDiff7
;Sweep_12F683.mpas,30 :: 		else
L__TickDiff6:
;Sweep_12F683.mpas,31 :: 		diff:=cur-pre;
	MOVF       FARG_TickDiff_pre+0, 0
	SUBWF      FARG_TickDiff_cur+0, 0
	MOVWF      R2+0
L__TickDiff7:
;Sweep_12F683.mpas,32 :: 		Result:=diff>=limit;
	MOVF       FARG_TickDiff_limit+0, 0
	SUBWF      R2+0, 0
	MOVLW      255
	BTFSS      STATUS+0, 0
	MOVLW      0
	MOVWF      R1+0
;Sweep_12F683.mpas,33 :: 		end;
	MOVF       R1+0, 0
	MOVWF      R0+0
L_end_TickDiff:
	RETURN
; end of _TickDiff

_SetPWMFreq:

;Sweep_12F683.mpas,36 :: 		begin
;Sweep_12F683.mpas,37 :: 		while TMR2IF_bit=0 do ;
L__SetPWMFreq10:
	BTFSS      TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
	GOTO       L__SetPWMFreq10
;Sweep_12F683.mpas,38 :: 		PR2:=99-delta;
	MOVF       FARG_SetPWMFreq_delta+0, 0
	SUBLW      99
	MOVWF      PR2+0
;Sweep_12F683.mpas,39 :: 		CCPR1L:=(PR2+1) shr 1;
	INCF       PR2+0, 0
	MOVWF      R2+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVF       R0+0, 0
	MOVWF      CCPR1L+0
;Sweep_12F683.mpas,40 :: 		end;
L_end_SetPWMFreq:
	RETURN
; end of _SetPWMFreq

_main:

;Sweep_12F683.mpas,42 :: 		begin
;Sweep_12F683.mpas,43 :: 		OSCCON:=$70;        // 8MHz
	MOVLW      112
	MOVWF      OSCCON+0
;Sweep_12F683.mpas,44 :: 		CMCON0:=7;
	MOVLW      7
	MOVWF      CMCON0+0
;Sweep_12F683.mpas,45 :: 		ANSEL:=%00000000;   // ADC not used
	CLRF       ANSEL+0
;Sweep_12F683.mpas,47 :: 		TRISIO0_bit:=0;     // LED -> Output
	BCF        TRISIO0_bit+0, BitPos(TRISIO0_bit+0)
;Sweep_12F683.mpas,50 :: 		TRISIO2_bit:=1;
	BSF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;Sweep_12F683.mpas,51 :: 		PR2:=99;            // 2000000 / (99+1) = 20000Hz
	MOVLW      99
	MOVWF      PR2+0
;Sweep_12F683.mpas,52 :: 		CCP1CON:=%00001100;
	MOVLW      12
	MOVWF      CCP1CON+0
;Sweep_12F683.mpas,53 :: 		CCPR1L:=50;
	MOVLW      50
	MOVWF      CCPR1L+0
;Sweep_12F683.mpas,54 :: 		TMR2IF_bit:=0;
	BCF        TMR2IF_bit+0, BitPos(TMR2IF_bit+0)
;Sweep_12F683.mpas,55 :: 		T2CON:=%00000100;
	MOVLW      4
	MOVWF      T2CON+0
;Sweep_12F683.mpas,56 :: 		TRISIO2_bit:=0;
	BCF        TRISIO2_bit+0, BitPos(TRISIO2_bit+0)
;Sweep_12F683.mpas,58 :: 		PWM_last:=0;
	CLRF       _PWM_last+0
;Sweep_12F683.mpas,59 :: 		ClrWDT;
	CLRWDT
;Sweep_12F683.mpas,61 :: 		LED:=0;
	BCF        GP0_bit+0, BitPos(GP0_bit+0)
;Sweep_12F683.mpas,62 :: 		LED_last:=0;
	CLRF       _LED_last+0
;Sweep_12F683.mpas,65 :: 		T1CON:=%00110000;
	MOVLW      48
	MOVWF      T1CON+0
;Sweep_12F683.mpas,66 :: 		TMR1IF_bit:=0;
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
;Sweep_12F683.mpas,67 :: 		TICK_100:=0;
	CLRF       _TICK_100+0
;Sweep_12F683.mpas,69 :: 		Delay_100ms;
	CALL       _Delay_100ms+0
;Sweep_12F683.mpas,70 :: 		ClrWDT;
	CLRWDT
;Sweep_12F683.mpas,72 :: 		TMR1IE_bit:=1;
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
;Sweep_12F683.mpas,73 :: 		PEIE_bit:=1;
	BSF        PEIE_bit+0, BitPos(PEIE_bit+0)
;Sweep_12F683.mpas,74 :: 		GIE_bit:=1;
	BSF        GIE_bit+0, BitPos(GIE_bit+0)
;Sweep_12F683.mpas,75 :: 		TMR1ON_bit:=1;       // Timer1
	BSF        TMR1ON_bit+0, BitPos(TMR1ON_bit+0)
;Sweep_12F683.mpas,77 :: 		while True do begin
L__main16:
;Sweep_12F683.mpas,79 :: 		if TickDiff(TICK_100,LED_last,10) then
	MOVF       _TICK_100+0, 0
	MOVWF      FARG_TickDiff_cur+0
	MOVF       _LED_last+0, 0
	MOVWF      FARG_TickDiff_pre+0
	MOVLW      10
	MOVWF      FARG_TickDiff_limit+0
	CALL       _TickDiff+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main21
;Sweep_12F683.mpas,81 :: 		LED:=not LED;
	MOVLW
	XORWF      GP0_bit+0, 1
;Sweep_12F683.mpas,82 :: 		LED_last:=TICK_100;
	MOVF       _TICK_100+0, 0
	MOVWF      _LED_last+0
;Sweep_12F683.mpas,83 :: 		ClrWDT;
	CLRWDT
;Sweep_12F683.mpas,84 :: 		end;
L__main21:
;Sweep_12F683.mpas,86 :: 		if TickDiff(TICK_100,PWM_last,PWM_int) then
	MOVF       _TICK_100+0, 0
	MOVWF      FARG_TickDiff_cur+0
	MOVF       _PWM_last+0, 0
	MOVWF      FARG_TickDiff_pre+0
	MOVF       _PWM_int+0, 0
	MOVWF      FARG_TickDiff_limit+0
	CALL       _TickDiff+0
	MOVF       R0+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L__main24
;Sweep_12F683.mpas,88 :: 		PWM_int:=rand() mod 60+30;
	CALL       _rand+0
	MOVLW      60
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVLW      30
	ADDWF      R0+0, 0
	MOVWF      _PWM_int+0
;Sweep_12F683.mpas,89 :: 		PWM_delta:=rand() mod 30;
	CALL       _rand+0
	MOVLW      30
	MOVWF      R4+0
	CLRF       R4+1
	CALL       _Div_16x16_S+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVF       R8+1, 0
	MOVWF      R0+1
	MOVF       R0+0, 0
	MOVWF      _PWM_delta+0
;Sweep_12F683.mpas,90 :: 		SetPWMFreq(PWM_delta);
	MOVF       R0+0, 0
	MOVWF      FARG_SetPWMFreq_delta+0
	CALL       _SetPWMFreq+0
;Sweep_12F683.mpas,91 :: 		PWM_last:=TICK_100;
	MOVF       _TICK_100+0, 0
	MOVWF      _PWM_last+0
;Sweep_12F683.mpas,92 :: 		end;
L__main24:
;Sweep_12F683.mpas,93 :: 		end;
	GOTO       L__main16
;Sweep_12F683.mpas,94 :: 		end.
L_end_main:
	GOTO       $+0
; end of _main
