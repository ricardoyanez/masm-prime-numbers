TITLE Primes     (Proj4_yanezr.asm)

; Author: Ricardo Yanez
; Last Modified: 5/15/2022
; OSU email address: yanezr@oregonstate.edu
; Course number/section: CS271 Section 404
; Project Number: 4 Due Date: 5/15/2022
; Description: Display prime numbes from 1 to n, where n is user supplied and
;              less or equal to 200.

INCLUDE Irvine32.inc

; define limits
LO = 1
HI = 200

; define boolean
FALSE = 0
TRUE = 1

.data

  greeting		BYTE	"Prime Numbers Programmed by Ricardo",13,10,10,0

  instruct		BYTE	"Enter the number of prime numbers you would like to see.",13,10
				BYTE	"I'll accept orders for up to 200 primes.",13,10,10,0

  prompt1		BYTE	"Enter the number of primes to display [",0
  dash			BYTE	" ... ",0
  prompt2		BYTE	"]: ",0

  num			DWORD	?			; number of primes
  mum			DWORD	?
  mun			DWORD	?
  lun			DWORD	0           ; count of primes
  bprime		DWORD	?           ; isPrime boolean
  bvalid		DWORD	?           ; validate boolean

  invalid		BYTE	"No primes for you! Number out of range. Try again.",13,10,0
  space			BYTE	"   ",0

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
	CMP bvalid, FALSE
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

	; preserve registers
	PUSH EAX
	PUSH EDX

    MOV bvalid, TRUE
	CMP num, LO
	JL _invalid
	CMP EAX, HI
	JLE _valid

	; number is not in range
_invalid:
	MOV EDX, OFFSET invalid
	CALL WriteString
    MOV bvalid, FALSE

_valid:

	; restore registers
	POP EDX
	POP EAX

    RET
  validate ENDP

;------------------------------------------------------;
; Name: showPrimes                                     ;
;                                                      ;
; Loop over num and display if mum is a prime number.  ;
;                                                      ;
; Receives: num holds the number of primes to display. ;
;------------------------------------------------------;
  showPrimes PROC

	; preserve registers
	PUSH EAX
	PUSH EBX
    PUSH ECX
	PUSH EDX

    MOV ECX, num
	MOV mum, 0
	MOV lun, 0

_loop:
	INC mum
    CALL isPrime
	MOV EBX, bprime
	CMP EBX, 0
	JE _loop

	; here we have a prime number
	INC lun
	MOV EAX, mum
	CALL WriteDec
	MOV EDX, OFFSET space
	CALL WriteString

	; if display 10 prime numbers, new line
	MOV EDX, 0
	MOV EAX, lun
	MOV EBX, 10
	DIV EBX
	CMP EDX, 0
	JG _next
	CALL CrLf
_next:
	LOOP _loop

	; restore registers
	POP EDX
	POP ECX
	POP EBX
	POP EAX

	RET
  showPrimes ENDP

;---------------------------------------------------------------------------;
; Name: isPrime                                                             ;
;                                                                           ;
; Determines if a number is a prime                                         ;
;                                                                           ;
; Receives: the global variable mum must hold the prime number.             ;
;                                                                           ;
; Returns: the global variable bprime is 1 if number is prime, 0 otherwise. ;
;---------------------------------------------------------------------------;
  isPrime PROC
	; preserve registers
	PUSH EAX
	PUSH EBX
	PUSH ECX
	PUSH EDX

	MOV bprime, FALSE
	CMP mum, 1          ; 1 is not a prime number
	JE _not_prime
	CMP mum, 2          ; 2 is a prime number
	JE _is_prime
    MOV	mun, 2
	; loop from 2 to mum/2
_loop:
	MOV EDX, 0
	MOV EAX, mum
	DIV mun
	CMP EDX, 0
	; if mum % mun is zero, mum is divisable and not a prime
	JE _not_prime
	MOV EAX, mun
	MOV EBX, 2
	MUL EBX
	CMP EAX, mum
	JG _is_prime
    INC mun
	JNE _loop
_is_prime:
	MOV bprime, TRUE

_not_prime:

	; restore registers
	POP EDX
	POP ECX
	POP EBX
	POP EAX
    RET
  isPrime ENDP


  farewell PROC

	RET
  farewell ENDP

END main
