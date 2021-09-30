" This file is copied directly from http://vi.stackexchange.com/a/5988/1060

syn keyword registerKeyword r0 r1 r2 r3 r4 r5 r6 r7 r8 r9 r10 r11 r12 r13 r14 r15 
syn keyword registerKeyword r16 r17 r18 r19 r20 r21 r22 r23 r24 r25 r26 r27 r28 r29 r30 r31 

syn keyword registerKeyword R0 R1 R2 R3 R4 R5 R6 R7 R8 R9 R10 R11 R12 R13 R14 R15 
syn keyword registerKeyword R16 R17 R18 R19 R20 R21 R22 R23 R24 R25 R26 R27 R28 R29 R30 R31 

syn match regPartBit '.t\d\+' contains=registerKeyword
syn match regPartWord '.w\d\+' contains=registerKeyword

hi def link registerKeyword PreProc
hi def link regPartBit PreProc
hi def link regPartWord PreProc

" Preprocessor commands

syn keyword preprocWord setcallreg entrypoint origin assign enter leave using macro mparam endm struct ends
syn keyword preprocType u32 u16 u8
hi def link preprocWord PreProc
hi def link preprocType Type

syn match filenameString '".*"' contained
syn match includeLine '^#include\s.*$' contains=filenameString
syn match defineLine '^#define\s'
syn match ifdefLine '^#if[n]\?def\s'
syn match ifdefLine '\v^#endif[\t\n ]'

hi def link filenameString string
hi def link includeLine include
hi def link defineLine define
hi def link ifdefLine PreProc

" Instruction mnemonics
syn keyword instructionKeyword add adc sub suc rsb rsc
syn keyword instructionKeyword lsl lsr and or xor not min max clr set scan lmbd
syn keyword instructionKeyword mov ldi mvib mviw mvid lbbo sbbo lbco sbco zero
syn keyword instructionKeyword jmp jal call ret qbgt qbge qblt qble qbeq qbne qba qbbs qbbc wbs wbc halt slp

" Define constant registers from PRU

syn keyword constantKeyword c0 c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15 
syn keyword constantKeyword c16 c17 c18 c19 c20 c21 c22 c23 c24 c25 c26 c27 c28 c29 c30 c31 

syn keyword constantKeyword C0 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10 C11 C12 C13 C14 C15 
syn keyword constantKeyword C16 C17 C18 C19 C20 C21 C22 C23 C24 C25 C26 C27 C28 C29 C30 C31 

hi def link constantKeyword PreProc

" Define labels

syn match label '^[^ ]\+:'

hi def link label Identifier

" Define comments

syn match synComment ";.*$"
syn match synComment "//.*$"
hi def link synComment Comment
