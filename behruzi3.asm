;Ali Behrouzi
;HW3
;write date 15/9/96
;this program gets 2 number and use 3 subprogram to calculate the number of occurrence of second number in first ,store base 2 of the first number in bmsg array ,calculate the length of bmsg array,and also show that is bmsg palindrom or not!
.386
.MODEL FLAT

ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD

INCLUDE io.h            ; header file for input/output

cr      EQU     0Dh     ; carriage return character
Lf      EQU     0Ah     ; line feed

.STACK  4096            ; reserve 4096-byte stack

.DATA                   ; reserve storage for data
msgfirst	BYTE    cr, Lf, "Ali Behrouzi, HW3, 15/9/96, "
			BYTE	cr, Lf,cr,lf, "this program gets 2 number and use 3 subprogram..."
			byte    cr,lf,"to calculate the number of occurrence of second number in first"
			byte 	cr,lf,"and store base 2 of the first number in bmsg array "
			byte	cr,lf,"and calculate the length of bmsg array"
			byte	cr,lf,"and also show that is bmsg palindrom or not!",cr,Lf,cr,Lf,0




msg1 byte cr,lf,"Welcome to the 3rd assembly program that uses subprogram for:"
	 byte cr,lf,"    a) FindDigit(n, d), Counts the no. of digits d(0 <= d <=9) in integer n"
	 byte cr,lf,"    b) displayBinary(n, bmsg, len) Computes base 2 of integer n and stores in bmsg"
	 byte cr,lf,"    c) isPalindrome(bmsg, len), Checks if bmsg of length len is palindrom?",cr,lf,0
	 
msg2 byte cr,lf,"Please enter positive integer n:",cr,lf,0
msg3 byte cr,lf,"Please enter positive integer d(0 <= d <=9):",cr,lf,0

string byte 10 dup(?)
n	dword	?
d	word	?
bmsg	byte	16 dup(?)
arrtemp	byte	16 dup(?)
len		byte	?
lenTemp	byte	?
lenTemp2	word ?
divide	dword	?
runCounter	word	0
repCounter	word	?
div10	dword	10
div2	dword	2
ntemp	dword	?

prtFnd1	byte	cr,lf,"There are",0
prtFnd2 byte	6 dup(?)," occurrence of",0
prtFnd3	byte	11 dup(?)," in ",0
prtFnd4 byte	11 dup(?),cr,lf,0

prtDisply1 byte cr,lf,"Base 2 of",0
prtDisply2 byte	11 dup(?)," is ",0
prtDisply3 byte	", len = ",0
prtDisply4 byte 6 dup(?),cr,lf,0

prtNotPall1	byte	cr,lf,"Ooops, ",0
prtNotPall2 byte	" is not Palindrome!",cr,lf,0

prtIsPall1	byte	cr,lf,"Thanks God, ",0
prtIsPall2  byte	" is palindrome!",cr,lf,0

msgAsk	byte	cr,lf,"Do you want to continue?(y/n):",cr,lf,0
msgWrngAns	byte	cr,Lf,"your answer is not valid , please enter y or n..!",0

prtNo1	byte	cr,lf,"Thanks and have a nice day,...... You tried this program",0
prtNo2	byte	6 dup(?)," times.",cr,lf,0


.CODE                           ; start of main program code
_start:
MAIN    PROC    NEAR32			; Main Program
output	msgfirst
lableStart:
		inc runCounter
		output msg1
		output msg2
		
		input string,10
		
		atod	string
		mov	n,eax
		
		output msg3
		input string,10
		atoi string 
		mov d,ax
		
		push n
		push d
		
		call FindDigit
		jmp	next1
		FindDigit proc near32
			mov	repCounter,0
			push ebp
			mov ebp,esp
			mov	ax,[ebp+8]
			cwde
			mov	divide,eax
			
			mov	eax,[ebp+10]
			mov	ntemp,eax
			mov	ecx,eax
		for2:
			cdq
			idiv	div10
			cmp	edx,divide
			je	for1
			cmp	eax,0
			je	end1
			jmp	for2

			
		for1:
			inc	repCounter
			cmp	eax,0
			je	end1
			jmp	for2
		
		end1:
			itoa	prtFnd2,repCounter
			dtoa	prtFnd3,divide
			dtoa	prtFnd4,ntemp
			
			output	prtFnd1
			output	prtFnd2+3
			output	prtFnd3+9
			output	prtFnd4+7
			
			pop	ebp
			ret	6
		FindDigit	endp
		
		
		
		next1:
		lea	esi,n
		push	esi
		lea esi,bmsg
		push	esi
		lea	esi,len
		push esi
		
		call displayBinary
		jmp	next2
		displayBinary proc near32
			push ebp
			mov ebp,esp
			mov esi,0
			mov	lenTemp,0
			
			mov	ecx,[ebp+16]
			mov	eax,[ecx]
			mov	ntemp,eax
			mov	ebx,[ebp+12];use this for bmsg
			mov	eax,ntemp
		for3:
			cdq
			idiv	div2
			cmp edx,0
			je	for4
			mov	cl,'1'
			mov	[ebx+esi],cl
			
			inc	lenTemp
		
			cmp	eax,0
			je	end2
			add	esi,2
			jmp	for3
		for4:
			mov	cl,'0'
			mov	[ebx+esi],cl
			inc	lenTemp
			
			cmp	eax,0
			je	end2
			add	esi,2
			jmp	for3
			
		end2:
			mov eax,[ebp+8]
			mov	cl,lenTemp
			mov	[eax],cl
			
		print1:
			output	prtDisply1
			dtoa	prtDisply2,ntemp
			output	prtDisply2+7
		printBmsg:
			output	[ebx+esi]
			sub	esi,2
			cmp	esi,0
			jl	end3
			jmp	printBmsg
			
		end3:
			output	prtDisply3
			mov	cl,lenTemp
			movzx	cx,cl
			itoa	prtDisply4,cx
			output	prtDisply4+4
			pop	ebp
			ret	12
		displayBinary	endp
		
		next2:


		lea	esi,bmsg
		push	esi
		lea	esi,len
		push	esi
		
		call	isPalindrome
		jmp	next3
		isPalindrome proc near32
			push ebp
			mov	ebp,esp
			mov	eax,[ebp+8]
			mov	al,[eax]
			mov	ebx,[ebp+12];use this for bmsg
			dec	al
			cbw
			imul	ax,2
			mov	lenTemp2,ax
			mov	ecx,0
			
		for5:
			
			mov	dl,[ebx+ecx]
			
			mov	ax,lenTemp2
			
			cwde
			
			cmp	[ebx+eax],dl
			
			jne	end4
			add	ecx,2
			sub	lenTemp2,2
			mov	ax,lenTemp2
			cwde
			cmp	ecx,eax
			
			jg	end6
			jmp	for5
		end4:
			output	prtNotPall1
			mov	eax,[ebp+8]
			mov	al,[eax]
			dec	al
			cbw
			imul	ax,2
			mov	lenTemp2,ax
		printBmsg2:
			mov	ax,lenTemp2
			cwde
			output	[ebx+eax]
			
			sub	lenTemp2,2
			mov	ax,lenTemp2
			cwde
			mov	esi,eax
			
			cmp	esi,0
			jl	print2
			jmp	printBmsg2
		print2:
			output prtNotPall2
			jmp end7
		
		end6:
			output	prtIsPall1
			mov	eax,[ebp+8]
			mov	al,[eax]
			dec	al
			cbw
			imul	ax,2
			mov	lenTemp2,ax
		printBmsg3:
			mov	ax,lenTemp2
			cwde
			output	[ebx+eax]
			
			sub	lenTemp2,2
			mov	ax,lenTemp2
			cwde
			mov	esi,eax
			
			cmp	esi,0
			jl	print3
			jmp	printBmsg3
		print3:
			output	prtIsPall2
			jmp end7
		end7:
			pop ebp
			ret	8
		isPalindrome	endp
		
		next3:
		
			output	msgAsk
			input	string,10
			cmp		string,'y'
			je		lableStart
			cmp		string,'n'
			je		forNo
			output	msgWrngAns
			jmp		next3
		
		forNo:
			output	prtNo1
			itoa	prtNo2,runCounter
			output  prtNo2+4
			jmp	finalEnd
		finalEnd:
        INVOKE  ExitProcess, 0	; exit with return code 0
MAIN    ENDP					; end of main
PUBLIC _start					; make entry point public

END                             ; end of source code