" Vim syntax file
" Language:     TI MSP430 Assembler (Microchip's microcontroller)
" Maintainer:   
" Last Change:  2003-08-06
" URL:          
" Revision:     1.1
"
" Revision History
" 1.0   2003-07-18      Initial version
" 1.1   2003-08-06      Add minimal support for C style comments

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case match
syn keyword mspTodo NOTE TODO XXX contained


syn case ignore

syn match mspIdentifier "[a-z_$][a-z0-9_$]*"
syn match mspLabel      "^[A-Z_$][A-Z0-9_$]*"
"syn match mspLabel      "^[A-Z_$][A-Z0-9_$]*:"me=e-1

"syn match mspASCII      "A\='.'"
syn match mspBinary     "B'[0-1]\+'"
syn match mspDecimal    "D'\d\+'"
syn match mspDecimal    "\d\+"
syn match mspHexadecimal "0x\x\+"
syn match mspHexadecimal "H'\x\+'"
syn match mspHexadecimal "[0-9]\x*h"
syn match mspOctal      "O'[0-7]\o*'"


syn match mspComment    ";.*" contains=mspTodo

syn region mspString    start=+"+ end=+"+

syn keyword mspRegister         INDF TMR0 PCL STATUS FSR PORTA PORTB
syn keyword mspRegister         EEDATA EEADR PCLATH INTCON INDF OPTION_REG PCL
syn keyword mspRegister         FSR TRISA TRISB EECON1 EECON2 INTCON OPTION


" Register --- bits

" STATUS
syn keyword mspRegisterPart     C Z N V GIE CPUOFF OSCOFF SCG0 SCG1

" Registers
syn match   mspRegister         "R[0-9]"
syn match   mspRegister         "R1[0-5]"

syn keyword mspRegister         IE1 IE1_ 
syn keyword mspRegisterPart     WDTIE OFIE NMIIE ACCVIE URXIE0 UTXIE0
syn keyword mspRegister         IFG1 IFG1_
syn keyword mspRegisterPart     WDTIFG OFIFG NMIIFG URXIFG0 UTXIFG0
syn keyword mspRegister         ME1 ME1_
syn keyword mspRegisterPart     URXE0 USPIE0 UTXE0
syn keyword mspRegister         IE2 IE2_
syn keyword mspRegisterPart     URXIE1 UTXIE1
syn keyword mspRegister         IFG2 IFG2_
syn keyword mspRegisterPart     URXIFG1 UTXIFG1
syn keyword mspRegister         ME2 ME2_
syn keyword mspRegisterPart     URXE1 USPIE1 UTXE1
syn keyword mspRegister         WDCTL
syn keyword mspRegisterPart     WDTIS0 WDTIS1 WDTSSEL WDTCNTCL WDTTMSEL
syn keyword mspRegisterPart     WDTNMI WDTNMIES WDTHOLD WDTPW
" Hardware Multiplier
syn keyword mspRegister         MPY MPY_ MPYS MPYS_ MAC MAC_ OP2 OP2_ 
syn keyword mspRegister         RESLO RESLO_ RESHI RESHI_ SUMEXT SUMEXT_
" Ports
syn match   mspRegister         "P[1-2]IFG"
syn match   mspRegister         "P[1-2]IES"
syn match   mspRegister         "P[1-2]IE"
syn match   mspRegister         "P[1-5]SEL"
syn match   mspRegister         "P[1-5]DIR"
syn match   mspRegister         "P[1-5]OUT"
syn match   mspRegister         "P[1-5]IN"
" USART
syn keyword mspRegister         UCTL[0-1] UCTL[0-1]_ U[0-1]CTL U[0-1]CTL_
syn keyword mspRegisterPart     PENA PEV SPB CHAR LISTEN SYNC MM SWRST
syn keyword mspRegister         UTCTL[0-1] UTCTL[0-1]_ U[0-1]TCTL  U[0-1]TCTL_ 
syn keyword mspRegisterPart     CKPH CEPL SSEL1 SSEL0 URXSE TXWAKE STC TXEPT
syn keyword mspRegister         URCTL[0-1] URCTL[0-1]_ U[0-1]RCTL U[0-1]RCTL_
syn keyword mspRegisterPart     FE PE OE BRK URXEIE URXWIE RXWAKE RXERR
syn keyword mspRegister         UBR[0-1][0-1] U[0-1]BR[0-1]
syn keyword mspRegister         UTXBUF[0-1] U[0-1]TXBUF
syn keyword mspRegister         URXBUF[0-1] U[0-1]RXBUF
syn keyword mspRegister         UMCTL[0-1] U[0-1]MCTL
" Timers
syn keyword mspRegister         T[A-B]IV T[A-B]CTL TACCTL[0-2] TBCCTL[0-6] 
syn keyword mspRegister         T[A-B]R TACCR[0-2] TBCCR[0-6]
syn keyword mspRegister         CCTL[0-2] CCR[0-2]
syn keyword mspRegisterPart     TASSEL[0-2] ID[0-1] MC[0-1] TACLR TAIE TAIFG
syn keyword mspRegisterPart     TASSEL_[0-3] ID_[0-1] MC_[0-3]
syn keyword mspRegisterPart     CM[0-1] CCIS[0-1] SCS SCCI CAP OUTMOD[0-2] CCIE CCI OUT COV CCIFG
syn keyword mspRegisterPart     OUTMOD_[0-7] CCIS_[0-3] CM_[0-3]
syn keyword mspRegisterPart     SHR[0-1] TBCLGRP[0-1] CNTL[0-1]
syn keyword mspRegisterPart     SLSHR[0-1] CLLD[0-1] SLSHR_[0-3] CLLD_[0-3]
" Basic Clock Module
syn keyword mspRegister         DCOCTL BCSCTL[1-2]
syn keyword mspRegisterPart     MOD[0-4] DCO[0-2] 
syn keyword mspRegisterPart     RSEL[0-2] XT5V DIVA[0-1] XTS XT2OFF DIVA_[0-3]
syn keyword mspRegisterPart     DCOR DIVS[0-1] SELS DIVM[0-1] SELM[0-1]
syn keyword mspRegisterPart     DIVS_[0-3] DIVM_[0-3] SELM_[0-3]
" Flash Memory
syn keyword mspRegister         FCTL[1-3]
syn keyword mspRegisterPart     FRKEY FWKEY FXKEY
syn keyword mspRegisterPart     ERASE MERAS WRT BLKWRT SEGWRT
syn keyword mspRegisterPart     FN[0-5] FSSEL[0-1] FSSEL_[0-3]
syn keyword mspRegisterPart     BUSY KEYV ACCVIFG WAIT LOCK EMEX
" EPROM Control
syn keyword mspRegister         EPCTL EPEXE EPVPPS
" Comparator A
syn keyword mspRegister         CACTL[1-2] CAPD
syn keyword mspRegisterPart     CAIFG CAIE CAIES CAON CAREF[0-1] CARSEL CAEX
syn keyword mspRegisterPart     CAREF_[0-3]
syn keyword mspRegisterPart     CAOUT CAF P2CA[0-1] CACTL2[4-7] 
syn keyword mspRegisterPart     CAPD[0-7]
" ADC 12
syn keyword mspRegister         ADC12CTL[0-1] ADC12IFG ADC12IE ADC12IV ADC12MEM
syn keyword mspRegister         ADC12MEM ADC12MEM[0-9] ADC12MEM1[0-5]
syn keyword mspRegister         ADC12MCTL[0-9] ADC12MCTL1[0-5]
syn keyword mspRegisterPart     ADC12SC ENC ADC12TOVIE ADC12OVIE ADC12ON REFON REF2_5V MSH MSC
syn keyword mspRegisterPart     SHT[0-1]_[0-9] SHT[0-1]_1[0-5]
syn keyword mspRegisterPart     ADC12BUSY CONSEQ_[0-3] ADC12SSEL_[0-3] ADC12DIV_[0-7]
syn keyword mspRegisterPart     ISSH SHP SHS_[0-3]
syn keyword mspRegisterPart     CSTARTADD_[0-9] CSTARTADD_1[0-5]
syn keyword mspRegisterPart     INCH_[0-9] INCH_[0-5]
syn keyword mspRegisterPart     SREF_[0-7] EOS

"Interrupt Vectors
syn keyword mspLabel         PORT2_VECTOR UART1TX_VECTOR UART1RX_VECTOR
syn keyword mspLabel         PORT1_VECTOR TIMERA1_VECTOR TIMERA0_VECTOR
syn keyword mspLabel         ADC_VECTOR UART0TX_VECTOR UART0RX_VECTOR   
syn keyword mspLabel         WDT_VECTOR COMPARATORA_VECTOR TIMERB1_VECTOR
syn keyword mspLabel         TIMERB0_VECTOR NMI_VECTOR RESET_VECTOR 

" OpCodes...
syn keyword mspOpcode  ADC ADD ADDC AND BIC BIS BIT BR CALL CLRC CLRN CLRZ
syn keyword mspOpcode  CMP DADC DADD DEC DECD DINT EINT INC INCD INV JC JHS
syn keyword mspOpcode  JEQ JZ JGE JL JMP JN JNC JLO JNE JNZ MOV NOP POP PUSH
syn keyword mspOpcode  RET RETI RLA RLC RRA RRC SBC SETC SETN SETZ SUB SUBC
syn keyword mspOpcode  SWPB SXT TST XOR         SIZEOF 
syn match mspOpcode     "[.][BW]"


" Directives
syn keyword mspDirective CONSTANT DATA DS DB DE DT DW ELSE END ENDC
syn keyword mspDirective ENDIF ENDM ENDW EQU ERROR ERRORLEVEL EXITM EXPAND
syn keyword mspDirective EXTERN FILL GLOBAL IDATA __IDLOCS IF IFDEF IFNDEF
syn keyword mspDirective INCLUDE LIST LOCAL MACRO __MAXRAM MESSG NOEXPAND
syn keyword mspDirective NOLIST ORG PAGE PAGESEL PROCESSOR RADIX RES SET
syn keyword mspDirective SPACE SUBTITLE TITLE UDATA UDATA_OVR UDATA_SHR
syn keyword mspDirective VARIABLE WHILE INCLUDE
syn keyword mspDirective MODULE NAME EXTERN ENDMOD PUBLIC RSEG COMMON
"syn keyword mspDirective # @ ( )
syn match mspDirective   "#\=UNDEFINE"
syn match mspDirective   "#\=INCLUDE"
syn match mspDirective   "#\=DEFINE"

syn keyword mspStorage   UDATA0 IDATA0 ECSTR NO_INIT CODE CSTACK

"syn region cCommentL	start="//" skip="\\$" end="$" keepend contains=@cCommentGroup,cSpaceError
"syn region cComment	matchgroup=cCommentStart start="/\*" matchgroup=NONE end="\*/" contains=@cCommentGroup,cCommentStartError,cSpaceError
syn region cCommentL	start="//" skip="\\$" end="$" keepend 
syn region cComment	matchgroup=cCommentStart start="/\*" matchgroup=NONE end="\*/" 

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_pic16f84_syntax_inits")
  if version < 508
    let did_pic16f84_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink mspTodo               Todo
  HiLink mspComment            Comment
  HiLink cComment              Comment
  HiLink cCommentL             Comment
  HiLink mspDirective          Statement
  HiLink mspLabel              Label
  HiLink mspString             String

  HiLink mspOpcode            Keyword
  HiLink mspRegister          Structure
  "HiLink mspRegisterPart      Special
  HiLink mspStorage           Special

  HiLink mspASCII              String
  HiLink mspBinary             Number
  HiLink mspDecimal            Number
  HiLink mspHexadecimal        Number
  HiLink mspOctal              Number

  HiLink mspIdentifier         Identifier

  delcommand HiLink
endif

let b:current_syntax = "msp"

" vim: ts=8
