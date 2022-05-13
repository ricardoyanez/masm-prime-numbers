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

  greeting		BYTE	"Prime Numbers Programmed by Ricardo Yanez",13,10,10,0

  instruct		BYTE	"Enter the number of prime numbers you would like to see.",13,10
				BYTE	"I'll accept orders for up to 200 primes.",13,10,10,0

  prompt1		BYTE	"Enter the number of primes to display [",0
  prompt2		BYTE	"]: ",0

  dots			BYTE	" ... ",0
  space			BYTE	"   ",0

  num			DWORD	?			; number of primes
  mum			DWORD	?
  mun			DWORD	?
  lun			DWORD	0           ; count of primes
  bprime		DWORD	?           ; isPrime boolean
  bvalid		DWORD	?           ; validate boolean

  invalid		BYTE	"No primes for you! Number out of range. Try again.",13,10,0

  prompt3		BYTE	"Results certified by Ricardo Yanez. Goodbye.",13,10,0

.code
main PROC

  CALL introduction
  CALL getUserData
  CALL showPrimes
  CALL farewell

  Invoke ExitProcess,0	; exit to operating system
main ENDP


;------------------------------------------------------;
; Name: introduction                                   ;
;                                                      ;
; Display program title and instructions.              ;
;                                                      ;
; Preconditions: prompt string must have been defined. ;
;------------------------------------------------------;
  introduction PROC
	; preserve registers
	PUSH EDX

	MOV EDX, OFFSET greeting	; display greeting
	CALL WriteString

	; restore registers
	POP EDX
	RET
  introduction ENDP


; -----------------------------------------------------;
; Name: getUserData                                    ;
;                                                      ;
; Get the input from user.                             ;
;                                                      ;
; Preconditions: prompt string must have been defined. ;
;                                                      ;
; Postconditions: num is within the range.             ;
; -----------------------------------------------------;
  getUserData PROC

	; preserve registers
	PUSH EDX

	MOV EDX, OFFSET instruct	; display instructions
	CALL WriteString

_start:
	CALL getValue
	CALL validate
	CMP bvalid, FALSE
	JG _continue
	JMP _start
_continue:

	; restore registers
	POP EDX

	RET
  getUserData ENDP

;------------------------------------------------------;
; Name: getValue                                       ;
;                                                      ;
; Prompt and read for a user supplied value.           ;
;                                                      ;
; Preconditions: prompt string must have been defined. ;
;                                                      ;
; Returns: num, the user input.                        ;
;------------------------------------------------------;
  getValue PROC

	; preserve registers
	PUSH EAX
	PUSH EDX

	; display prompt with limits
	MOV EDX, OFFSET prompt1
	CALL WriteString
	MOV EAX, LO
	CALL WriteDec
	MOV EDX, OFFSET dots
	CALL WriteString
	MOV EAX, HI
	CALL WriteDec
	MOV EDX, OFFSET prompt2
	CALL WriteString

	; read the value
	CALL ReadDec
	MOV num, EAX

	; restore registers
	POP EDX
	POP EAX

	RET
  getValue ENDP


;
;--------------------------------------------------------------;
; Name: validate                                               ;
;                                                              ;
; Validate number in the [LO-HI] range                         ;
;                                                              ;
; Preconditions: prompt strings must have been defined.        ;
;                                                              ;
; Receives: num, the number of primes to display               ;
;                                                              ;
; Returns: Boloean bvalid, 1 if within the range, 0 otherwise. ;
;--------------------------------------------------------------;
  validate PROC

	; preserve registers
	PUSH EDX

	MOV bvalid, TRUE
	CMP num, LO
	JL _invalid
	CMP num, HI
	JLE _valid

	; number is not in range
  _invalid:
	MOV EDX, OFFSET invalid
	CALL WriteString
	MOV bvalid, FALSE

  _valid:

	; restore registers
	POP EDX

	RET
  validate ENDP


;------------------------------------------------------;
; Name: showPrimes                                     ;
;                                                      ;
; Loop over num and display if mum is a prime number.  ;
;                                                      ;
; Preconditions: prompt string must have been defined. ;
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
	CALL CrLf

	; extra line if not starting a new line
	CMP EDX, 0
	JE _next1
	CALL CrLf
  _next1:

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


;------------------------------------------------------;
; Name: farewell                                       ;
;                                                      ;
; Display end credits                                  ;
;                                                      ;
; Preconditions: prompt string must have been defined. ;
;------------------------------------------------------;
  farewell PROC
	; preserve registers
	PUSH EDX

	MOV EDX, OFFSET prompt3
	CALL WriteString

	; restore registers
	POP EDX
	RET
  farewell ENDP

END main
