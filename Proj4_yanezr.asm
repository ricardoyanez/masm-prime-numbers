TITLE Program Template     (template.asm)

; Author: Ricardo Yanez
; Last Modified: 5/15/2022
; OSU email address: yanezr@oregonstate.edu
; Course number/section:   CS271 Section 404
; Project Number: 4   Due Date: 5/15/2022
; Description: This file is provided as a template from which you may work
;              when developing assembly projects in CS271.

INCLUDE Irvine32.inc

; (insert macro definitions here)

; define limits
LO = 1
HI = 200

.data

  greeting		BYTE	"Prime Numbers Programmed by Ricardo",13,10,10,0

  instruct		BYTE	"Enter the number of prime numbers you would like to see.",13,10
				BYTE	"I'll accept orders for up to 200 primes.",13,10,10,0

  prompt1		BYTE	"Enter the number of primes to display [",0
  dash			BYTE	"-",0
  prompt2		BYTE	"]: ",0

  num			DWORD	?			; number of primes

  valid			DWORD	?
  invalid		BYTE	"No primes for you! Number out of range. Try again.",13,10,0

.code
main PROC

  CALL introduction
  CALL getUserData
  CALL showPrimes
  CALL farewell

  Invoke ExitProcess,0	; exit to operating system
main ENDP

  introduction PROC
    MOV EDX, OFFSET greeting	; display greeting
	CALL WriteString
	RET
  introduction ENDP

  getUserData PROC
    MOV EDX, OFFSET instruct	; display instructions
	CALL WriteString

_start:
	CALL getValue
	CALL validate
	CMP valid, 0
	JG _continue
	JMP _start
_continue:

	RET
  getUserData ENDP

  ;
  ; procedure get value
  ;
  getValue PROC
	; display prompt with limits
	MOV EDX, OFFSET prompt1
	CALL WriteString
	MOV EAX, LO
	CALL WriteDec
	MOV EDX, OFFSET dash
	CALL WriteString
	MOV EAX, HI
	CALL WriteDec
	MOV EDX, OFFSET prompt2
	CALL WriteString

	; get value
	CALL ReadDec
	MOV num, EAX

	RET
  getValue ENDP

  ;
  ; procedure validate
  ; validate number in [LO-HI] range
  ;
  validate PROC

    MOV valid, 1
	CMP num, LO
	JL _invalid
	CMP EAX, HI
	JLE _valid

; number is not in range
_invalid:
	MOV EDX, OFFSET invalid
	CALL WriteString
    MOV valid, 0

_valid:

    RET
  validate ENDP


  showPrimes PROC

	RET
  showPrimes ENDP

  farewell PROC

	RET
  farewell ENDP

END main
