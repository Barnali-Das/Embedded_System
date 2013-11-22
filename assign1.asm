		Title		""
		list		p=16f877a
		#include	<p16f877a.inc>
		__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _HS_OSC & _WRT_OFF & _LVP_OFF & _CPD_OFF
		
;	pin assignment:
		RB0			EQU			H'0'		;LED_1
		RB1			EQU			H'1'		;LED_2
		RB2			EQU			H'2'		;LED_3
		RB3			EQU			H'3'		;LED_4
		RB4			EQU			H'4'		;LED_5
		RB5			EQU			H'5'		;LED_6
		RB6			EQU			H'6'		;LED_7
		RB7			EQU			H'7'		;LED_8
		










---------------------------------------------------------------
;
---------------------------------------------------------------
LIST P=16F877 
 INCLUDE “P16F877.INC” 
 
 ORG 0x0000 
 BANKSEL PORTB ; Bank 0 
 CLRF PORTB ; Reset PORTB 
 BANKSEL TRISB ; Bank 1 
 CLRF TRISB ; Port B = All Outputs 
 MOVLW 0x0E ; Chan 0, AN0, Left Justify 
 MOVWF ADCON1 
 BSF TRISA,0 ; RA0 = Input 
 BANKSEL PORTB ; Bank 0 
 MOVLW 0x41 ; ADC = “on”, Chan 0 Select, 
 MOVWF ADCON0 ; Clock = Fosc / 8 
 MAIN: 
 BCF PIR1,ADIF ; Reset “ADC Done” 
 BSF ADCON0,GO ; Start ADC 
 CLRWDT ; Reset Watch-Dog Timer 
 
 TEST: 
 BTFSS PIR1,ADIF ; Is ADC Finished?
GOTO TEST 
 
 MOVF ADRESH,W ; Get Raw ADC Data 
 MOVWF PORTB ; Send to Port B 
 GOTO MAIN 
 END 
--------------------------------------------------------------
;intialization of port A
--------------------------------------------------------------
BCF STATUS, RP0 ;
BCF STATUS, RP1 ; Bank0
CLRF PORTA ; Initialize PORTA by
; clearing output
; data latches
BSF STATUS, RP0 ; Select Bank 1
MOVLW 0x06 ; Configure all pins
MOVWF ADCON1 ; as digital inputs
MOVLW 0xCF ; Value used to 
; initialize data 
; direction
MOVWF TRISA ; Set RA<3:0> as inputs
; RA<5:4> as outputs
; TRISA<7:6>are always
; read as '0'.
