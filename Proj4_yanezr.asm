TITLE Display Prime Numbers     (Proj4_yanezr.asm)

; Author: Ricardo Yanez
; Last Modified: 5/15/2022
; OSU email address: yanezr@oregonstate.edu
; Course number/section: CS271 Section 404
; Project Number: 4 Due Date: 5/15/2022
; Description: Display prime numbers from 1 to n, where n is user supplied and
;              less or equal to 200 (extended to 4000 as per Extra Credit).

INCLUDE Irvine32.inc

; define limits
LO = 1
HI = 4000

; define boolean
FALSE = 0
TRUE = 1

.data

  greeting		BYTE	"Prime Numbers Programmed by Ricardo Yanez",13,10,10,0

  instruct		BYTE	"Enter the number of prime numbers you would like to see.",13,10
				BYTE	"I'll accept orders for up to 200 primes.",13,10,10,0

  prompt1		BYTE	"Enter the number of primes to display [",0
  prompt2		BYTE	"]: ",0

  dash			BYTE	"-",0
  space			BYTE	" ",0

  num			DWORD	?			; number of primes to display
  mum			DWORD	?			; internal variable for isprime
  mun			DWORD	?			; internal variable for isprime
  lun			DWORD	0           ; count primes

  bprime		DWORD	?           ; prime boolean
  bvalid		DWORD	?           ; validate boolean

  invalid		BYTE	"No primes for you! Number out of range. Try again.",13,10,0

  prompt3		BYTE	"Results certified by Ricardo. Goodbye.",13,10,0

  prompt_ec1	BYTE	"EC: Align the output columns",13,10,0
  prompt_ec2	BYTE	"EC: Extend the range of primes to display up to 4000 primes",13,10,10,0

  prompt4		BYTE	"Press any key to continue... ",0
  pow10			DWORD	?

.code
main PROC

  CALL introduction		; Display greeting and instructions
  CALL getUserData		; Get a value and validate
  CALL showPrimes		; Display the prime numbers
  CALL farewell			; Display end credits

  Invoke ExitProcess,0	; exit to operating system
main ENDP


;---------------------------------------------------;
; Name: introduction                                ;
;                                                   ;
; Display program title and instructions.           ;
;                                                   ;
; Preconditions: strings greeting, instruct,        ;
;                prompt_ec1 and prompt_ec2 declared ;
;                                                   ;
; Postconditions: none                              ;
;                                                   ;
; Receives: global variables greeting, instruct,    ;
;                  prompt_ec1 and prompt_ec2        ;
;                                                   ;
; Returns: none                                     ;
;---------------------------------------------------;
  introduction PROC

	PUSH EDX	; preserve registers

	;-----------------
	; display greeting
	;-----------------
	MOV EDX, OFFSET greeting
	CALL WriteString

	;-------------
	; Extra Credit
	;-------------
	MOV EDX, OFFSET prompt_ec1
	CALL WriteString
	MOV EDX, OFFSET prompt_ec2
	CALL WriteString

	;---------------------
	; display instructions
	;---------------------
	MOV EDX, OFFSET instruct
	CALL WriteString

	POP EDX		; restore registers

	RET
  introduction ENDP


; -------------------------------------------------------;
; Name: getUserData                                      ;
;                                                        ;
; Get the input from user.                               ;
;                                                        ;
; Preconditions: boolean global variable bvalid declared ;
;                                                        ;
; Postconditions: input variable num is within the range ;
;                                                        ;
; Receives: none                                         ;
;                                                        ;
; Returns: none                                          ;
; -------------------------------------------------------;
  getUserData PROC

	;--------------------------
	; get a value and validate
	; if not valid, start again
	;--------------------------
  _loop:
	CALL getValue
	CALL validate
	CMP bvalid, FALSE
	JG _continue
	JMP _loop
  _continue:

	RET
  getUserData ENDP


;------------------------------------------------------;
; Name: getValue                                       ;
;                                                      ;
; Prompt and read a user supplied value.               ;
;                                                      ;
; Preconditions: prompt strings prompt_1, prompt_2 and ;
;                dash declared. global variable num    ;
;                declared. constants LO, HI defined    ;
;                                                      ;
; Postconditions: none                                 ;
;                                                      ;
; Receives: none                                       ;
;                                                      ;
; Returns: num, the user input.                        ;
;------------------------------------------------------;
  getValue PROC

	PUSH EAX	; preserve registers
	PUSH EDX

	;---------------------------
	; display prompt with limits
	; --------------------------
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

	;---------------
	; read the value
	;---------------
	CALL ReadDec
	MOV num, EAX

	POP EDX		; restore registers
	POP EAX

	RET
  getValue ENDP


;
;-------------------------------------------------------------;
; Name: validate                                              ;
;                                                             ;
; Validate number in the [LO-HI] range                        ;
;                                                             ;
; Preconditions: prompt string invalid declared.              ;
;                boolean global variable bvalid declared.     ;
;                constants LO, HI defined                     ;
;                                                             ;
; Postconditions: none                                        ;
;                                                             ;
; Receives: num, the number of primes to display              ;
;                                                             ;
; Returns: Boolean bvalid, 1 if within the range, 0 otherwise ;
;-------------------------------------------------------------;
  validate PROC

	PUSH EDX	; preserve registers

	; --------------------------------
	; check if num is within the range
	; --------------------------------
	MOV bvalid, TRUE
	CMP num, LO
	JL _invalid
	CMP num, HI
	JLE _valid

	; ----------------------
	; number is not in range
	; display error
	;-----------------------
  _invalid:
	MOV EDX, OFFSET invalid
	CALL WriteString
	MOV bvalid, FALSE

  _valid:

	POP EDX		; restore registers

	RET
  validate ENDP


;--------------------------------------------------------;
; Name: showPrimes                                       ;
;                                                        ;
; Loop over num and display if mum is a prime number.    ;
;                                                        ;
; Preconditions: global variables mum and lin declared.  ;
;                boolean global bprime variable declared ;
;                                                        ;
; Postconditions: none                                   ;
;                                                        ;
; Receives: num holds the number of primes to display    ;
;                                                        ;
; Returns: none                                          ;
;--------------------------------------------------------;
  showPrimes PROC

	PUSH EAX	; preserve registers
	PUSH EBX
	PUSH ECX
	PUSH EDX

	;-----------------------------
	; define loop couter and reset
	; the other counters
	;-----------------------------
	MOV ECX, num
	MOV mum, 0
	MOV lun, 0
	CALL CrLf

	;----------------------------
	; loop and check if tentative
	; number is a prime
	; it it is, continue
	;----------------------------
  _loop:
	INC mum
	CALL isPrime
	MOV EBX, bprime
	CMP EBX, 0
	JE _loop

	;----------------------------
	; here we have a prime number
	; display the number
	;----------------------------
	INC lun
	MOV EAX, mum
	CALL WriteDec
	CALL WriteSpace

	;--------------------------------------
	; if multiple of 10 prime numbers
	; have been displayed, issue a new line
	;--------------------------------------
	MOV EDX, 0
	MOV EAX, lun
	MOV EBX, 10
	DIV EBX
	CMP EDX, 0
	JG _next
	CALL CrLf

	;------------------------------------
	; if multiple of 200 prime numbers
	; have been displayed, issue a prompt
	; to continue
	;------------------------------------
	MOV EDX, 0
	MOV EAX, lun
	MOV EBX, 200
	DIV EBX
	CMP EDX, 0
	JG _next
	MOV EDX, OFFSET prompt4
	CALL WriteString
	CALL ReadChar
	CALL CrLf

  _next:
	LOOP _loop
	CALL CrLf

	;--------------------------------------
	; extra line if not starting a new line
	;--------------------------------------
	CMP EDX, 0
	JE _done
	CALL CrLf

  _done:

	POP EDX		; restore registers
	POP ECX
	POP EBX
	POP EAX

	RET
  showPrimes ENDP


;------------------------------------------------------;
; Name: WriteSpace                                     ;
;                                                      ;
; Fill spaces depending on the number of digits        ;
;                                                      ;
; Preconditions: global variabel pow10 declared        ;
;                                                      ;
; Postconditions: none                                 ;
;                                                      ;
; Receives: string space, mum holds the prime number   ;
;                                                      ;
; Returns: none                                        ;
;------------------------------------------------------;
  WriteSpace PROC

	PUSH EAX	; preserve registers
	PUSH EBX
	PUSH EDX

	MOV EDX, OFFSET space
	CALL WriteString

	;---------------------------------------------
	; divide the number by decreasing powers of 10
	; if integer part is zero, print a space
	;---------------------------------------------
	MOV pow10, 10000
  _loop:
	MOV EDX, 0
	MOV EAX, mum
	MOV EBX, pow10
	DIV EBX
	CMP EAX, 0
	JG _jump
	MOV EDX, OFFSET space
	CALL WriteString
  _jump:
	;-----------------------------
	; decrease the exponent by one
	;-----------------------------
	MOV EDX, 0
	MOV EAX, pow10
	MOV EBX, 10
	DIV EBX
	CMP EAX, 1
	JE _done
	MOV pow10, EAX
	JMP _loop
  _done:

	POP EDX		; restore registers
	POP EBX
	POP EAX

	RET
  WriteSpace ENDP


;---------------------------------------------------------;
; Name: isPrime                                           ;
;                                                         ;
; Determines if a number is a prime                       ;
;                                                         ;
; Preconditions: global variable mun declared             ;
;                                                         ;
; Postconditions: none                                    ;
;                                                         ;
; Receives: the global variable mum must hold the number  ;
;           to test                                       ;
;                                                         ;
; Returns: the boolean variable bprime is 1 if mun is     ;
;          prime, 0 otherwise.                            ;
;---------------------------------------------------------;
  isPrime PROC

	PUSH EAX	; preserve registers
	PUSH EBX
	PUSH ECX
	PUSH EDX

	MOV bprime, FALSE

	;-----------------------
	; 1 and 2 are base cases
	;-----------------------
	CMP mum, 1		; 1 is not a prime number
	JE _not_prime
	CMP mum, 2		; 2 is a prime number
	JE _is_prime
	MOV	mun, 2

	;-----------------------------------------------
	; loop mun from 2 to half the number
	; and test if number is divisible by mun.
	; if it is, then number cannot be a prime number
	;-----------------------------------------------
  _loop:
	MOV EDX, 0
	MOV EAX, mum
	DIV mun
	CMP EDX, 0
	;------------------------------------
	; if mum % mun == 0, mum is divisible
	; by mun and therefore not a prime
	;------------------------------------
	JE _not_prime
	MOV EAX, mun
	MOV EBX, 2
	MUL EBX
	CMP EAX, mum
	JG _is_prime
	INC mun
	JNE _loop

	;----------------
	; number is prime
	;----------------
  _is_prime:
	MOV bprime, TRUE

  _not_prime:

	POP EDX		; restore registers
	POP ECX
	POP EBX
	POP EAX

    RET
  isPrime ENDP


;-------------------------------------------------------;
; Name: farewell                                        ;
;                                                       ;
; Display end credits                                   ;
;                                                       ;
; Preconditions: string prompt3 defined                 ;
;                                                       ;
; Postconditions: none                                  ;
;                                                       ;
; Receives: prompt3 string global variable              ;
;                                                       ;
; Returns: none                                         ;
;-------------------------------------------------------;
  farewell PROC

	PUSH EDX	; preserve registers

	;--------------------
	; display end credits
	;--------------------
	MOV EDX, OFFSET prompt3
	CALL WriteString

	POP EDX		; restore registers

	RET
  farewell ENDP

END main
