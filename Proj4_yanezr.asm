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

.data

.code
main PROC

  CALL introduction
  CALL getUserData
  CALL showPrimes
  CALL farewell

  Invoke ExitProcess,0	; exit to operating system
main ENDP

  introduction PROC
	RET
  introduction ENDP

  getUserData PROC
	RET
  getUserData ENDP

  showPrimes PROC
	RET
  showPrimes ENDP

  farewell PROC
	RET
  farewell ENDP

END main
