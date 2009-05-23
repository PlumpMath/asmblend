; reading blender file - asm dabblings

format PE console
include 'win32ax.inc'

.code

	SYSTEM	EQU win32
	include '%FASMLIB%/include/fasm/fasmlib-src.inc'

	idata {
	      _err_format db 10, "ERROR: %s!", 10, 0
	      nl	  db 10, 0
	      blend	  db 'matrix_warp_3.blend',0	;25 744 312 bytes long
	      sizepref	  db 'file contains ',0
	      sizepost	  db ' bytes',10, 0
	}
	idata {
	      ENDB			db 'ENDB'
	      DNA1			db 'DNA1'
	      BIGENDIAN 		db 'V'
	      ISBIGENDIAN		db 'This file is saved as bigendian',0
	      ISSMALLENDIAN		db 'This file is saved as smallendian',0
	      SMALLENDIAN		db 'v'
	      OFFSET_BITS		db 7
	      OFFSET_ENDIAN		db 8
	      _32BIT			db '-'
	      _64BIT			db '_'
	      IS32BIT			db 'This file is saved with 32bit',0
	      IS64BIT			db 'This file is saved with 64bit',0
	      OFFSET_LENGTH		db 4
	      OFFSET_OLD_POINTER	db 8
	      OFFSET_SDNA_INDEX 	db 8
	      OFFSET_NUMBER		db 12

	}
	udata {
	      bhandle	rd	1
	      header	rd	13
	}

start:
	call	fasmlib.init
	jc	error
	call	mem.init
	jc	error

	push	0
	push	blend
	call	fileio.open
	jc	error
	mov	[bhandle], eax

	push	2
	push	0
	push	0
	push	[bhandle]
	call	fileio.seek

	push	[bhandle]
	call	fileio.tell

	push	edx
	push	eax
	call	stdout.write.q_dec

	push	nl
	call	stdout.write

	push	0
	push	0
	push	0
	push	[bhandle]
	call	fileio.seek

	push	12
	push	header
	push	[bhandle]
	call	fileio.read

	mov	[header+12], 0

	push	header
	call	stdout.write


.closefile:
	push	[bhandle]
	call	fileio.close

.done:
	call	mem.uninit

	jmp	exit
error:
	;EAX = error message associated with error code
	push   eax
	call   err.text

	push   eax
	push   _err_format
	call   stderr.write.format
exit:
	call	fasmlib.uninit

	push	1
	call	process.exit

.data
	IncludeIData
	IncludeUData
.end start