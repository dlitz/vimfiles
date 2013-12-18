" Vim syntax file
" Language:    NSIS 2.46 script
" Maintainer:  Chris Morgan <me@chrismorgan.info>
" Last Change: 2012 March 5
" Version:     2.46-2
" Changelog:
 " 2.45-1:
     " updated to NSIS 2.45
 " 2.45-2:
     " fixed missing colouring of nsisConstVar
 " 2.45-3:
     " fixed ; or # comment characters at end of line making the next line a comment
     " fixed ${|} and ${||} LogicLib highlighting
     " changed nsisTodo list's contents and added it and @Spell to a new nsisCommentGroup
 " 2.46-1:
     " improved !else to highlight the optional if((macro)?n?def) argument
     " added SetPluginUnload (not in NSIS user manual; deprecated but still used)
     " fixed highlighting of any single character as Number (bad decimal rule)
     " started doing incorrect syntax error highlighting and only highlighting arguments in the proper place
     " added the line continuation character (\)
     " variable highlighting (far from perfect and doesn't auto-update, but it may be helpful)
     " added extra Unicode NSIS instructions (and nsis_no_unicode_instructions to not highlight them):
         " FileReadWord, FileReadUTF16LE
         " FileWriteWord, FileWriteUTF16LE
         " FindProc
     " added MB_USERICON to MessageBox parameters
 " 2.46-2:
     " highlight $\' and $\` as well as $\"


" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore
syn sync fromstart

"Scripting Reference: (4)
"Comments: (4.1.2)
syn keyword nsisTodo	TODO FIXME XXX
syn cluster nsisCommentGroup contains=nsisTodo
if !exists("g:nsis_no_spell_comments")
 syn cluster nsisCommentGroup add=@Spell
endif

syn match nsisLineContinuation "\\\s*$" containedin=ALL nextgroup=nsisArbitraryString skipnl
syn region nsisComment  start="[;#]" skip="\\\s*$" end="$"   contains=@nsisCommentGroup 
syn region nsisComment  start="/\*"                end="\*/" contains=@nsisCommentGroup containedin=ALLBUT,@nsisString,nsisComment

"Plugins: (4.1.3)
" Highlighting ${...::...} is intentional, gets used by some plug-ins (e.g. registry)
syn match nsisPluginCall	"^\s*\zs[^ 	;#]\{-}::\S\+"
"Strings: (4.1.5)
syn cluster nsisQuotedStringContents contains=nsisPreprocSubst,nsisLangSubst,nsisUserVar,nsisSysVar,nsisConstVar
syn cluster nsisStringContents       contains=@nsisQuotedStringContents,nsisNumber
" nsisNumber is left out of @nsisStringContents intentionally. Highlighting
" numbers inside strings looks a bit silly.
syn region nsisString	start=/"/ skip=/'\|`/ end=/"/ end=/$/ contains=@nsisQuotedStringContents
syn region nsisString	start=/'/ skip=/"\|`/ end=/'/ end=/$/ contains=@nsisQuotedStringContents
syn region nsisString	start=/`/ skip=/"\|'/ end=/`/ end=/$/ contains=@nsisQuotedStringContents
syn match  nsisCompilerNumber		"\s\d\+"ms=s+1 skipwhite contained nextgroup=nsisComment,nsisTrailingError
syn region nsisCompilerString		start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisComment,nsisTrailingError
syn region nsisCompilerString2		start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisCompilerString
syn region nsisCompilerString3		start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisCompilerString2
syn region nsisInstructionString 	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisComment,nsisTrailingError
syn region nsisInstructionString2	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisInstructionString
syn region nsisInstructionString3	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisInstructionString2
syn region nsisArbitraryString		start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisComment
syn cluster nsisString contains=nsisString,nsisInstructionString,nsisInstructionString2
syn match nsisTrailingError contained /\S.*/ skipwhite contains=nsisComment nextgroup=nsisComment
" TODO contained for all nsisString
syn match nsisConstVar	"$\\\""
syn match nsisConstVar	"$\\\'"
syn match nsisConstVar	"$\\\`"

"Numbers: (4.1.6)
syn match nsisNumber		"\s[1-9]\d*\ze\%(\s\|[;#]\|$\)"ms=s+1 " decimal
syn match nsisNumber		"\s0x\x\+\ze\%(\s\|[;#]\|$\)"ms=s+1   " hex
syn match nsisNumber		"\s0\o*\ze\%(\s\|[;#]\|$\)"ms=s+1     " octal
syn match nsisNumber		"\s\x\{6}\ze\%(\s\|[;#]\|$\)"ms=s+1   " hex colour


"Variables: (4.2)
"User Variables: (4.2.1.1) [Enhanced attribute handling]
syn match nsisVarCommand		"^\s*\zsVar\>" nextgroup=nsisAttribVarGlobal,nsisCompilerString skipwhite
syn match nsisAttribVarGlobal	'\s\/GLOBAL\>'ms=s+1 contained nextgroup=nsisCompilerString skipwhite

"Other Writable Variables: (4.2.2)
syn match nsisUserVar		"$\d"
syn match nsisUserVar		"$R\d"
syn match nsisSysVar		"$INSTDIR"
syn match nsisSysVar		"$OUTDIR"
syn match nsisSysVar		"$CMDLINE"
syn match nsisSysVar		"$LANGUAGE"
"Constants: (4.2.3)
syn match nsisConstVar		"$PROGRAMFILES"
syn match nsisConstVar		"$PROGRAMFILES32"
syn match nsisConstVar		"$PROGRAMFILES64"
syn match nsisConstVar		"$COMMONFILES"
syn match nsisConstVar		"$COMMONFILES32"
syn match nsisConstVar		"$COMMONFILES64"
syn match nsisConstVar		"$DESKTOP"
syn match nsisConstVar		"$EXEDIR"
syn match nsisConstVar		"$EXEFILE"
syn match nsisConstVar		"$EXEPATH"
syn match nsisConstVar		"${NSISDIR}"
syn match nsisConstVar		"$WINDIR"
syn match nsisConstVar		"$SYSDIR"
syn match nsisConstVar		"$TEMP"
syn match nsisConstVar		"$STARTMENU"
syn match nsisConstVar		"$SMPROGRAMS"
syn match nsisConstVar		"$SMSTARTUP"
syn match nsisConstVar		"$QUICKLAUNCH"
syn match nsisConstVar		"$DOCUMENTS"
syn match nsisConstVar		"$SENDTO"
syn match nsisConstVar		"$RECENT"
syn match nsisConstVar		"$FAVORITES"
syn match nsisConstVar		"$MUSIC"
syn match nsisConstVar		"$PICTURES"
syn match nsisConstVar		"$VIDEOS"
syn match nsisConstVar		"$NETHOOD"
syn match nsisConstVar		"$FONTS"
syn match nsisConstVar		"$TEMPLATES"
syn match nsisConstVar		"$APPDATA"
syn match nsisConstVar		"$LOCALAPPDATA"
syn match nsisConstVar		"$PRINTHOOD"
syn match nsisConstVar		"$INTERNET_CACHE"
syn match nsisConstVar		"$COOKIES"
syn match nsisConstVar		"$HISTORY"
syn match nsisConstVar		"$PROFILE"
syn match nsisConstVar		"$ADMINTOOLS"
syn match nsisConstVar		"$RESOURCES"
syn match nsisConstVar		"$RESOURCES_LOCALIZED"
syn match nsisConstVar		"$CDBURN_AREA"
syn match nsisConstVar		"$HWNDPARENT"
syn match nsisConstVar		"$PLUGINSDIR"
"Constants Used In Strings: (4.2.4)
syn match nsisConstVar		"$\$"
syn match nsisConstVar		"$\\r"
syn match nsisConstVar		"$\\n"
syn match nsisConstVar		"$\\t"

"Labels: (4.3)
syn match nsisLocalLabel	"^\s*\zs[^-+!$0-9.;#][^;#: 	]\{-}:\%($\|\s\+\)"
syn match nsisGlobalLabel	"^\s*\zs\.[^-+!$0-9][^;#: 	]\{-}:\%($\|\s\+\)"


"Compile Time Commands: (5)
"Compiler Utility Commands: (5.1)
syn match nsisAttribNonFatal	skipwhite "\s\/nonfatal\>"ms=s+1	nextgroup=nsisCompilerString contained 
syn region nsisCompilerStringSystem skipwhite start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisComment,nsisAttribSystemOp,nsisTrailingError
syn match nsisAttribSystemOp	skipwhite "\s\%(<>\|<\|>\|=\)\s"ms=s+1,me=e-1			nextgroup=nsisCompilerString contained
syn match nsisVerbose			skipwhite "\%([0-4]\|push\|pop\)\>"	nextgroup=nsisComment,nsisTrailingError contained

syn match nsisInclude			skipwhite "^\s*\zs!include\>"		nextgroup=nsisAttribNonFatal,nsisCompilerString
syn match nsisInclude			skipwhite "^\s*\zs!addincludedir\>"	nextgroup=nsisCompilerString
syn match nsisInclude			skipwhite "^\s*\zs!addplugindir\>"	nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!appendfile\>"	nextgroup=nsisCompilerString2
syn match nsisSystem			skipwhite "^\s*\zs!cd\>"			nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!delfile\>"		nextgroup=nsisAttribNonFatal,nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!echo\>"			nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!error\>"			nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!execute\>"		nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!packhdr\>"		nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!system\>"		nextgroup=nsisCompilerStringSystem
syn match nsisSystem			skipwhite "^\s*\zs!tempfile\>"		nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!warning\>"		nextgroup=nsisCompilerString
syn match nsisSystem			skipwhite "^\s*\zs!verbose\>"		nextgroup=nsisVerbose,nsisPreprocSubst,nsisTrailingError


"Predefines: (5.2)
"Nothing to add in here


"Read Environment Variables: (5.3) (at compile time)
syn match nsisPreprocSubst	"$%.\{-}%"


"Conditional Compilation: (5.4)
"syn match	nsisPreprocSubst	"${.\{-}}" contains=nsisLogicLibKeyword,nsisPreprocSubst
syn region	nsisPreprocSubst	start="${" end="}" contains=nsisLogicLibKeyword,nsisPreprocSubst
syn match	nsisDefine			skipwhite "^\s*\zs!define\>"					nextgroup=nsisAttribDefineDateArg,nsisAttribDefineSymbol,nsisAttribDefineFileArg,nsisAttribDefineMathArg
"!define ([/date|/utcdate] symbol [value]) | (/file symbol filename) | (/math symbol val1 OP val2)
"    OP=(+ - * / % & | ^)

syn match	nsisAttribDefineDateArg		skipwhite contained "\s\/\%(date\|utcdate\)\s"ms=s+1,me=e-1 nextgroup=nsisAttribDefineSymbol
syn region	nsisAttribDefineSymbol	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisComment contained nextgroup=nsisAttribDefineValue,nsisComment
syn region	nsisAttribDefineValue	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisTrailingError,nsisComment

syn match	nsisAttribDefineFileArg		skipwhite contained "\s\/file\s"ms=s+1,me=e-1 nextgroup=nsisAttribDefineFileSymbol
syn region	nsisAttribDefineFileSymbol	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisComment contained nextgroup=nsisAttribDefineFileName
syn region	nsisAttribDefineFileName	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisTrailingError,nsisComment

syn match	nsisAttribDefineMathArg		skipwhite contained "\s\/math\s"ms=s+1,me=e-1 nextgroup=nsisAttribDefineMathSymbol,nsisComment
syn region	nsisAttribDefineMathSymbol	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisComment contained nextgroup=nsisAttribDefineMathVal1,nsisComment
syn region	nsisAttribDefineMathVal1	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribDefineMathOp,nsisTrailingError
syn match	nsisAttribDefineMathOp		skipwhite contained "\s[+-\*/%&|^]\ze\s\S"ms=s+1 nextgroup=nsisAttribDefineMathVal2,nsisComment
syn region	nsisAttribDefineMathVal2	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisTrailingError,nsisComment

syn match	nsisDefine			skipwhite "^\s*\zs!undef\>"						nextgroup=nsisCompilerString
syn match	nsisPreCondit		skipwhite "^\s*\zs!if\>"						nextgroup=nsisAttribIf1
syn match	nsisPreCondit		skipwhite "^\s*\zs!if\%(macro\)\?n\?def\>"		nextgroup=nsisAttribIfDef1
syn match	nsisPreConditIf		skipwhite contained "if\>"						nextgroup=nsisAttribIf1
syn match	nsisPreConditIf		skipwhite contained "if\%(macro\)\?n\?def\>"	nextgroup=nsisAttribIfDef1
syn match	nsisAttribIf1		skipwhite contained transparent "\s[^!]."me=e-3 nextgroup=nsisAttribIf2 " horrible solution but it wasn't working otherwise...
syn match	nsisAttribIf1		skipwhite contained "\s!\s"ms=s+1,me=e-1 nextgroup=nsisAttribIf2
syn region	nsisAttribIf2		start="\s\S"ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribIf3,nsisAttribIf5,nsisComment,nsisTrailingError
syn match	nsisAttribIf3		skipwhite "\s\%(==\|!=\|<=\|>=\|<\|>\)\ze\s\S"ms=s+1 contained nextgroup=nsisAttribIf4
syn region	nsisAttribIf4		start="\s\S"ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribIf5,nsisComment,nsisTrailingError
syn match	nsisAttribIf5		skipwhite "\s\%(&\||\|&&\|||\)\ze\s\S"ms=s+1 contained nextgroup=nsisAttribIf1
syn region	nsisAttribIfDef1	start="\s\S"ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribIfDef2,nsisComment,nsisTrailingError
syn match	nsisAttribIfDef2	skipwhite "\s\%(&\||\|&&\|||\)\ze\s\S"ms=s+1 contained nextgroup=nsisAttribIfDef1
syn match	nsisPreCondit		skipwhite "^\s*\zs!else\>" nextgroup=nsisPreConditIf
syn match	nsisPreCondit		skipwhite "^\s*\zs!endif\>"			nextgroup=nsisTrailingError
syn match	nsisMacro			skipwhite "^\s*\zs!insertmacro\>"	nextgroup=nsisArbitraryString
syn match	nsisMacro			skipwhite "^\s*\zs!macro\>"			nextgroup=nsisArbitraryString
syn match	nsisMacro			skipwhite "^\s*\zs!macroend\>"		nextgroup=nsisTrailingError
syn match	nsisDefine			skipwhite "^\s*\zs!searchparse\>"	nextgroup=nsisAttribSearchParseArgs,nsisAttribSearchParseFile
syn region	nsisAttribSearchParseFile	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribSearchParseString,nsisComment
syn region	nsisAttribSearchParseString	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribSearchParseSymbol,nsisComment
syn region	nsisAttribSearchParseSymbol	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisComment contained nextgroup=nsisAttribSearchParseString,nsisComment
syn match	nsisAttribSearchParseArgs	skipwhite contained "\s\/\%(ignorecase\|noerrors\|file\)\s"ms=s+1,me=e-1 nextgroup=nsisAttribSearchParseArgs,nsisAttribSearchParseFile
syn match	nsisDefine			skipwhite "^\s*\zs!searchreplace\>"	nextgroup=nsisAttribSearchReplace
"syn match	nsisAttribOptions	'\/ignorecase'
"syn match	nsisAttribOptions	'\/noerrors'
"syn match	nsisAttribOptions	'\/file'


"Pages: (4.5)
syn keyword nsisStatement	Page UninstPage PageEx PageExEnd PageCallbacks


"Sections: (4.6)
syn keyword	nsisStatement		AddSize Section SectionEnd SectionIn SectionGroup SectionGroupEnd
syn match	nsisAttribOptions	'\/o'
syn keyword	nsisAttribOptions	RO


"Functions: (4.7)

"Functions Commands: (4.7.1)
syn match nsisStatement	skipwhite "^\s*\zsFunction\(\s\|;\|#\|$\)" nextgroup=nsisCallback,nsisInstructionString
syn match nsisStatement	skipwhite "^\s*\zsFunctionEnd\>" nextgroup=nsisTrailingError


"Callback Functions: (4.7.2)
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onGUIInit"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onInit"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onInstFailed"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onInstSuccess"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onGUIEnd"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onMouseOverSelection"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onRebootFailed"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onSelChange"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onUserAbort"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "\.onVerifyInstDir"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onGUIInit"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onInit"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onUninstFailed"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onUninstSuccess"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onGUIEnd"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onRebootFailed"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onSelChange"
syn match nsisCallback		contained skipwhite nextgroup=nsisTrailingError "un\.onUserAbort"


"Installer Attributes: (4.8)
syn match nsisAttribute	"^\s*\zs\%(BGFont\|BGGradient\|Caption\|ChangeUI\|CheckBitmap\|CompletedText\|ComponentText\|DetailsButtonText\|DirText\|DirVar\|FileErrorText\|Icon\|InstallButtonText\|InstallDir\)\>"
syn match nsisAttribute	"^\s*\zs\%(LicenseData\|LicenseText\|MiscButtonText\|Name\|OutFile\|SpaceTexts\|SubCaption\|UninstallButtonText\|UninstallCaption\|UninstallIcon\|UninstallSubCaption\|UninstallText\)\>"
syn match nsisAttribute	skipwhite "^\s*\zsAddBrandingImage\>"							nextgroup=nsisAttribLeftRightTopBottom,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsInstProgressFlags\>"							nextgroup=nsisAttribInstProgressFlags,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsInstType\>"									nextgroup=nsisAttribInstType,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsInstallColors\>"								nextgroup=nsisAttribInstallColors,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsLicenseBkColor\>"								nextgroup=nsisAttribLicenseBkColor,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsLicenseForceSelection\>"						nextgroup=nsisAttribLicenseForceSelection,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsRequestExecutionLevel\>"						nextgroup=nsisAttribRequestExecutionLevel,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsInstallDirRegKey\>"							nextgroup=nsisAttribRegistry,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zs\%(WindowIcon\|XPStyle\)\>"					nextgroup=nsisAttribOnOff,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsCRCCheck\>"									nextgroup=nsisAttribOnOffForce,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zs\%(AllowRootDirInstall\|AutoCloseWindow\)\>"	nextgroup=nsisAttribTrueFalse,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsDirVerify\>"									nextgroup=nsisAttribAutoLeave,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsBrandingText\>"								nextgroup=nsisAttribBrandingText,nsisCompilerString
syn match nsisAttribute	skipwhite "^\s*\zsShow\%(Uni\|I\)nstDetails\>"					nextgroup=nsisAttribHideShowNeverShow,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsSilent\%(Un\)\?Install\>"						nextgroup=nsisAttribNormalSilentSilentLog,nsisTrailingError
syn match nsisAttribute	skipwhite "^\s*\zsSetFont\>"									nextgroup=nsisAttribLang,nsisTrailingError
syn match nsisAttribInstallColors			skipwhite nextgroup=nsisTrailingError contained '\/windows\>'
syn match nsisAttribLicenseBkColor			skipwhite nextgroup=nsisTrailingError contained '\/gray\>\|\/windows\>'
syn match nsisAttribLicenseForceSelection	skipwhite nextgroup=nsisTrailingError contained '\%(checkbox\|radiobuttons\|off\)\>'
syn match nsisAttribRequestExecutionLevel	skipwhite nextgroup=nsisTrailingError contained '\%(none\|user\|highest\|admin\)\>'
syn match nsisAttribInstProgressFlags		skipwhite nextgroup=nsisTrailingError contained 'smooth\>\|colored\>'
syn match nsisAttribInstType				skipwhite nextgroup=nsisTrailingError contained '\/\%(NOCUSTOM\>\|CUSTOMSTRING=\|COMPONENTSONLYONCUSTOM\>\)'
syn match nsisAttribBrandingText			skipwhite nextgroup=nsisCompilerString contained '\/TRIM\%(LEFT\|RIGHT\|CENTER\)\>'
syn match nsisAttribTrueFalse				skipwhite nextgroup=nsisTrailingError contained '\%(true\|false\)\>'
syn match nsisAttribHideShowNeverShow		skipwhite nextgroup=nsisTrailingError contained '\%(hide\|show\|nevershow\)\>'
syn match nsisAttribOnOff					skipwhite nextgroup=nsisTrailingError contained '\%(on\|off\)\>'
syn match nsisAttribOnOffForce				skipwhite nextgroup=nsisTrailingError contained '\%(on\|off\|force\)\>'
syn match nsisAttribLang					skipwhite nextgroup=nsisTrailingError contained '\/LANG='
syn match nsisAttribAutoLeave				skipwhite nextgroup=nsisTrailingError contained '\%(auto\|leave\)\>'
syn match nsisAttribLeftRightTopBottom		skipwhite nextgroup=nsisTrailingError contained '\%(left\|right\|top\|bottom\)\>'
syn match nsisAttribNormalSilentSilentLog	skipwhite nextgroup=nsisTrailingError contained '\%(normal\|silent\|silentlog\)\>'
syn match nsisCompiler		skipwhite	"^\s*\zs\%(AllowSkipFiles\|SetDataBlockOptimize\|SetDateSave\)\>"	nextgroup=nsisAttribOnOff,nsisTrailingError
syn match nsisCompiler		skipwhite	"^\s*\zs\%(FileBufSize\|SetCompressorDictSize\)\>"	nextgroup=nsisCompilerString
syn match nsisCompiler		skipwhite	"^\s*\zsSetCompress\>"		nextgroup=nsisAttribSetCompress,nsisTrailingError
syn match nsisCompiler		skipwhite	"^\s*\zsSetCompressor\>"	nextgroup=nsisAttribSetCompressor,nsisAttribSetCompressorType,nsisTrailingError
syn match nsisCompiler		skipwhite	"^\s*\zsSetOverwrite\>"		nextgroup=nsisAttribSetOverwrite,nsisTrailingError
syn match nsisAttribSetCompress				skipwhite nextgroup=nsisTrailingError contained '\%(auto\|force\|off\)\>'
syn match nsisAttribSetCompressor			contained '\%(\/SOLID\|\/FINAL\)\>' skipwhite nextgroup=nsisAttribSetCompressor,nsisAttribSetCompressorType,nsisTrailingError
syn match nsisAttribSetCompressorType		skipwhite nextgroup=nsisTrailingError contained '\%(zlib\|bzip\|lzma\)\>'
syn match nsisAttribSetOverwrite			skipwhite nextgroup=nsisTrailingError contained '\%(on\|off\|try\|ifnewer\|ifdiff\|lastused\)\>'
syn match nsisVersionInfo	skipwhite	"^\s*\zsVIAddVersionKey\>"	nextgroup=nsisAttribLang,nsisCompilerString2
syn match nsisVersionInfo	skipwhite	"^\s*\zsVIProductVersion\>"	nextgroup=nsisCompilerString


"Instructions: (4.9)

"Various Arguments For Instructions: (4.9.*)
"syn keyword nsisAttribOptions	left right top bottom normal silent silentlog
"syn keyword nsisAttribOptions	zlib bzip2 lzma try ifnewer ifdiff 32 64 lastused
" next line put back temporarily for SetDetailsPrint
syn keyword nsisAttribOptions	lastused
syn keyword nsisAttribOptions	SET CUR END none listonly textonly both current all

"syn match nsisAttribOptions	'\/LANG='
"syn match nsisAttribOptions	'\/SOLID\>'
"syn match nsisAttribOptions	'\/FINAL\>'


"syn match nsisAttribOptions	'\/nonfatal\>'
"syn match nsisAttribOptions	'\/a\>'
"syn match nsisAttribOptions	'\/r\>'
"syn match nsisAttribOptions	'\/x\>'
"syn match nsisAttribOptions	'\/oname='
syn match nsisAttribOptions	'\/SILENT\>'
syn match nsisAttribOptions	'\/FILESONLY\>'
syn match nsisAttribOptions	'\/ifempty\>'
syn match nsisAttribOptions	'\/SHORT\>'
syn match nsisAttribOptions	'\/SD\>'

syn match nsisAttribOptions	'\/IMGID='
syn match nsisAttribOptions	'\/RESIZETOFIT\>'
syn match nsisAttribOptions	'\/BRANDING\>'

"syn keyword nsisExecShell	SW_SHOWNORMAL SW_SHOWMAXIMIZED SW_SHOWMINIMIZED SW_HIDE

syn keyword nsisAttribRegistry	HKCR HKLM HKCU HKU HKCC HKDD HKPD SHCTX HKEY_CLASSES_ROOT HKEY_LOCAL_MACHINE HKEY_CURRENT_USER HKEY_USERS HKEY_CURRENT_CONFIG HKEY_DYN_DATA HKEY_PERFORMANCE_DATA SHELL_CONTEXT

syn keyword nsisMessageBox	MB_OK MB_OKCANCEL MB_ABORTRETRYIGNORE MB_RETRYCANCEL MB_YESNO MB_YESNOCANCEL MB_ICONEXCLAMATION MB_ICONINFORMATION MB_ICONQUESTION MB_ICONSTOP MB_USERICON MB_TOPMOST MB_SETFOREGROUND MB_RIGHT MB_DEFBUTTON1 MB_DEFBUTTON2 MB_DEFBUTTON3 MB_DEFBUTTON4 IDABORT IDCANCEL IDIGNORE IDNO IDOK IDRETRY IDYES


"Basic Instructions: (4.9.1) [Enhanced attribute handling]
syn keyword	nsisInstruction Delete		nextgroup=nsisAttribRebootOK skipwhite
syn keyword	nsisInstruction Exec
syn keyword	nsisInstruction ExecShell	nextgroup=nsisAttribExecShellAction skipwhite
syn region	nsisAttribExecShellAction	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribExecShellCommand,nsisComment
syn region	nsisAttribExecShellCommand	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribExecShellSW,nsisAttribExecShellParams,nsisComment
syn region	nsisAttribExecShellParams	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribExecShellSW,nsisComment
syn match	nsisAttribExecShellSW	contained "\sSW_\%(SHOWNORMAL\|SHOWMAXIMIZED\|SHOWMINIMIZED\|HIDE\)"ms=s+1 nextgroup=nsisTrailingError
syn keyword	nsisInstruction ExecWait
syn keyword	nsisInstruction	File nextgroup=nsisAttribFile,nsisAttribFile2,nsisAttribFile3 skipwhite
syn match	nsisAttribFile	contained '\/\%(nonfatal\|a\)\>' nextgroup=nsisAttribFile,nsisAttribFile2,nsisAttribFile3 skipwhite
syn match	nsisAttribFile2	contained '\/r\>' nextgroup=nsisAttribFile3 skipwhite
syn match	nsisAttribFile3	contained '\/x\>' nextgroup=nsisAttribFile4 skipwhite
syn region	nsisAttribFile4	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribFile3,nsisInstructionString,nsisComment
syn match	nsisAttribFile2	contained '\/oname='
syn keyword	nsisInstruction Rename nextgroup=nsisAttribRebootOK skipwhite
syn match	nsisAttribRebootOK contained '\/REBOOTOK\>'
syn keyword	nsisInstruction	ReserveFile nextgroup=nsisAttribReserveFile,nsisAttribReserveFile2 skipwhite
syn match	nsisAttribReserveFile	contained '\/\%(nonfatal\|r\)\>' nextgroup=nsisAttribReserveFile,nsisAttribReserveFile2 skipwhite
syn match	nsisAttribReserveFile2	contained '\/x\>' nextgroup=nsisAttribReserveFile3 skipwhite
syn region	nsisAttribReserveFile3	start=/\s\S/ms=s+1 end=/\s\|;\|#/me=e-1 end=/$/ skipwhite contains=@nsisStringContents,nsisString,nsisComment contained nextgroup=nsisAttribReserveFile2,nsisComment
syn keyword	nsisInstruction RMDir nextgroup=nsisAttribRMDir skipwhite
syn match	nsisAttribRMDir contained '\/\%(REBOOTOK\|r\)\>' nextgroup=nsisAttribRMDir skipwhite
syn keyword	nsisInstruction	SetOutPath

"Registry And INI And File Instructions: (4.9.2)
syn keyword nsisInstruction	DeleteINISec DeleteINIStr DeleteRegKey DeleteRegValue EnumRegKey EnumRegValue ExpandEnvStrings FlushINI ReadEnvStr ReadINIStr ReadRegDWORD ReadRegStr WriteINIStr WriteRegBin WriteRegDWORD WriteRegStr WriteRegExpandStr

"General Purpose Instructions: (4.9.3)
syn keyword nsisInstruction	CallInstDLL CopyFiles CreateDirectory CreateShortCut GetDLLVersion GetDLLVersionLocal GetFileTime GetFileTimeLocal GetFullPathName GetTempFileName SearchPath RegDLL UnRegDLL
syn keyword nsisInstruction SetFileAttributes nextgroup=nsisAttribSetFileAttributes skipwhite
syn keyword nsisAttribSetFileAttributes contained NORMAL ARCHIVE HIDDEN OFFLINE READONLY SYSTEM TEMPORARY FILE_ATTRIBUTE_NORMAL FILE_ATTRIBUTE_ARCHIVE FILE_ATTRIBUTE_HIDDEN FILE_ATTRIBUTE_OFFLINE FILE_ATTRIBUTE_READONLY FILE_ATTRIBUTE_SYSTEM FILE_ATTRIBUTE_TEMPORARY

"Flow Control Instructions: (4.9.4)
syn keyword nsisInstruction	Abort Call ClearErrors GetCurrentAddress GetFunctionAddress GetLabelAddress Goto IfAbort IfErrors IfFileExists IfRebootFlag IfSilent IntCmp IntCmpU MessageBox Return Quit SetErrors StrCmp StrCmpS

"File Instructions: (4.9.5)
syn keyword nsisInstruction	FindClose FileOpen FileRead FileReadByte FileReadFromEnd FileSeek FileWrite FileWriteByte FileClose FindFirst FindNext
if !exists("nsis_no_unicode_instructions")
	syn keyword nsisInstruction	FileReadUTF16LE FileReadWord FileWriteUTF16LE FileWriteWord
endif

"Uninstaller Instructions: (4.9.6)
syn keyword nsisInstruction WriteUninstaller

"Miscellaneous Instructions: (4.9.7)
if !exists("nsis_no_unicode_instructions")
	syn keyword nsisInstruction FindProc
endif
syn keyword nsisInstruction	GetErrorLevel GetInstDirError InitPluginsDir Nop SetErrorLevel SetRegView SetShellVarContext Sleep
syn keyword nsisInstruction SetPluginUnload nextgroup=nsisAttribSetPluginUnload skipwhite
syn keyword nsisAttribSetPluginUnload contained alwaysoff manual

"String Manipulation Instructions: (4.9.8)
syn keyword nsisInstruction StrCpy StrLen

"Stack Support: (4.9.9)
syn keyword nsisInstruction Exch Pop Push

"Integer Support: (4.9.10)
syn keyword nsisInstruction IntFmt IntOp

"Reboot Instructions: (4.9.11)
syn match nsisInstruction	skipwhite "^\s*\zsReboot\>"	nextgroup=nsisTrailingError
syn match nsisInstruction	skipwhite "^\s*\zsSetRebootFlag\>"	nextgroup=nsisAttribTrueFalse,nsisTrailingError

"Install Logging Instructions: (4.9.12)
syn match nsisInstruction	skipwhite "^\s*\zsLogText\>"	nextgroup=nsisInstructionString
syn match nsisInstruction	skipwhite "^\s*\zsLogSet\>"	nextgroup=nsisAttribOnOff,nsisTrailingError

"Section Management: (4.9.13)
syn keyword nsisInstruction SectionSetFlags SectionGetFlags SectionSetText SectionGetText SectionSetInstTypes SectionGetInstTypes SectionSetSize SectionGetSize SetCurInstType GetCurInstType InstTypeSetText InstTypeGetText

"User Interface Instructions: (4.9.14)
syn keyword nsisInstruction BringToFront CreateFont DetailPrint EnableWindow FindWindow GetDlgItem HideWindow IsWindow LockWindow SendMessage 
syn match nsisInstruction	skipwhite "^\s*\zsSetAutoClose\>"	nextgroup=nsisAttribTrueFalse
syn keyword nsisInstruction SetBrandingImage SetDetailsView SetDetailsPrint SetCtlColors SetSilent ShowWindow

"Multiple Languages Instructions: (4.9.15)
syn keyword nsisInstruction LoadLanguageFile LangString LicenseLangString
syn match nsisLangSubst "$(.\{-})"


"Other Additions:

"LogicLib Definitions:
syn keyword nsisLogicLibKeyword	contained Abort Errors FileExists RebootFlag Silent Cmd SectionIsSelected SectionIsSubSection SectionIsSubSectionEnd SectionIsSectionGroup SectionIsSectionGroupEnd SectionIsBold SectionIsReadOnly SectionIsExpanded SectionIsPartiallySelected IfCmd If Unless IfNot AndIf AndUnless AndIfNot OrIf OrUnless OrIfNot Else ElseIf ElseUnless ElseIfNot EndIf EndUnless IfThen IfNotThen ForEach For ExitFor Next While ExitWhile EndWhile Do DoWhile DoUntil ExitDo Loop LoopWhile LoopUntil Continue Break Select CaseElse Case_Else Default Case Case2 Case3 Case4 Case5 EndSelect Switch EndSwitch
syn match nsisLogicLibKeyword contained /||\?/


"Search For Variable Declarations To Highlight Them:

if !exists("nsis_skip_variable_detecting")
	let i = 1
	while i <= line("$")
		let s:s = matchstr(getline(i), '\c^\s*Var\s\+\%(\/GLOBAL\s\+\)\?\zs[^;# ]*\ze\s*\%([;#].*\)\?')
		if s:s != ""
			"echo 'Found variable ' . s:s . ' in script'
			exe 'syn match nsisUserVar "$' . s:s . '"'
		endif
		let i = i + 1
	endwhile
endif

" TODO: this should go in an ftplugin
let s:includedfiles = []

fu! s:GetVars(f)
	for s:f in s:includedfiles
		if s:f == a:f
			return
		endif
	endfor
	let s:includedfiles += [s:s]
	if filereadable(a:f)
		for s:l in readfile(a:f)
			let s:s = matchstr(s:l, '\c^\s*Var\s\+\%(\/GLOBAL\s\+\)\?\zs[^;# ]*\ze\s*\%([;#].*\)\?')
			if s:s != ""
				"echo 'Found variable ' . s:s . ' in file ' . a:f
				exe 'syn match nsisUserVar "$' . s:s . '"'
			endif
			let s:s = matchstr(s:l, '\c^\s*!include\s\+\%(\/nonfatal\s\+\)\?\zs[^;# ]*\ze\s*\%([;#].*\)\?')
			if s:s != ""
				call s:GetVars(s:s)
			endif
		endfor
	endif
endfu

if !exists("nsis_skip_variable_detecting") && !exists("nsis_skip_include_variable_detecting")
	let s:i = 1
	while s:i <= line("$")
		let s:s = matchstr(getline(s:i), '\c^\s*!include\s\+\%(\/nonfatal\s\+\)\?\zs[^;# ]*\ze\s*\%([;#].*\)\?')
		if s:s != ""
			call s:GetVars(s:s)
		endif
		let s:i = s:i + 1
	endwhile
endif

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_nsis_syn_inits")

	if version < 508
		let did_nsys_syn_inits = 1
		command -nargs=+ HiLink hi link <args>
	else
		command -nargs=+ HiLink hi def link <args>
	endif


	HiLink nsisLogicLibKeyword				Conditional
	HiLink nsisInstruction					Function
	HiLink nsisComment						Comment
	HiLink nsisLocalLabel					Label
	HiLink nsisGlobalLabel					Label
	HiLink nsisPluginCall 					Special
	HiLink nsisLineContinuation				Special
	HiLink nsisStatement					Statement
	HiLink nsisTrailingError				Error
	HiLink nsisError						Error
	HiLink nsisString						String
	HiLink nsisAttribVarGlobal				Constant

	HiLink nsisAttribNonFatal				Constant
	HiLink nsisAttribSystemOp				Operator
	HiLink nsisAttribIf1					Operator
	HiLink nsisAttribIf3					Operator
	HiLink nsisAttribIf5					Operator
	HiLink nsisAttribIfDef2					Operator
	HiLink nsisAttribDefineDateArg			Constant
	HiLink nsisAttribDefineFileArg			Constant
	HiLink nsisAttribDefineMathArg			Constant
	HiLink nsisAttribDefineMathOp			Operator

	HiLink nsisAttribSearchParseArgs		Constant
	HiLink nsisAttribSearchParseSymbol		PreProc
	HiLink nsisVerbose						Constant

	HiLink nsisAttribInstallColors			Constant
	HiLink nsisAttribLicenseBkColor			Constant
	HiLink nsisAttribLicenseForceSelection	Constant
	HiLink nsisAttribRequestExecutionLevel	Constant
	HiLink nsisAttribInstProgressFlags		Constant
	HiLink nsisAttribInstType				Constant
	HiLink nsisAttribBrandingText			Constant
	HiLink nsisAttribTrueFalse				Constant
	HiLink nsisAttribHideShowNeverShow		Constant
	HiLink nsisAttribOnOff					Constant
	HiLink nsisAttribOnOffForce				Constant
	HiLink nsisAttribLang					Constant
	HiLink nsisAttribAutoLeave				Constant
	HiLink nsisAttribLeftRightTopBottom		Constant
	HiLink nsisAttribNormalSilentSilentLog	Constant

	HiLink nsisAttribSetCompress			Constant
	HiLink nsisAttribSetCompressor			Constant
	HiLink nsisAttribSetCompressorType		Constant
	HiLink nsisAttribSetOverwrite			Constant

	HiLink nsisAttribRMDir					Constant
	HiLink nsisAttribRebootOK				Constant
	HiLink nsisAttribSetPluginUnload		Constant
	HiLink nsisAttribOptions				Constant
	HiLink nsisAttribExecShellSW			Constant
	HiLink nsisAttribFile					Constant
	HiLink nsisAttribFile2					Constant
	HiLink nsisAttribFile3					Constant
	HiLink nsisAttribReserveFile			Constant
	HiLink nsisAttribReserveFile2			Constant
	HiLink nsisExecShell					Constant
	HiLink nsisAttribSetFileAttributes		Constant
	HiLink nsisMessageBox					Constant
	HiLink nsisAttribRegistry				Constant
	HiLink nsisNumber						Number
	HiLink nsisVarCommand					Type
	HiLink nsisUserVar						Identifier
	HiLink nsisSysVar						Identifier
	HiLink nsisConstVar						Identifier
	HiLink nsisAttribute					Type
	HiLink nsisCompiler						Type
	HiLink nsisVersionInfo					Type
	HiLink nsisTodo							Todo
	HiLink nsisCallback						Operator
	" preprocessor commands
	HiLink nsisPreprocSubst					PreProc
	HiLink nsisLangSubst					PreProc
	HiLink nsisDefine						Define
	HiLink nsisMacro						Macro
	HiLink nsisPreCondit					PreCondit
	HiLink nsisPreConditIf					PreCondit
	HiLink nsisInclude						Include
	HiLink nsisSystem						PreProc

	delcommand HiLink
endif

let b:current_syntax = "nsis"

