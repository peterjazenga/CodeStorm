{
    Copyright (c) 2002 by Marco van de Voort

    Syscall functions for i386 *BSD.

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
    MA 02110-1301, USA.

 ****************************************************************************

These functions are the same over all three BSDs, except that some have a
32-bit Errno, and some a 16-bit}

{$ifdef FPC_USE_SYSCALL}

procedure actualsyscall; assembler; {inline requires a dummy push IIRC}
    asm
         int $0x80
         jb .LErrorcode
         ret
.LErrorcode:
         call SetErrno
         movl  $-1,%eax
end;

function FpSysCall(sysnr:TSysParam):TSysResult; oldfpccall; assembler; [public,alias:'FPC_DOSYS0'];

asm
  movl  sysnr,%eax
  call  actualsyscall
end;

function FpSysCall(sysnr,param1:TSysParam):TSysResult; oldfpccall; assembler;[public,alias:'FPC_DOSYS1'];

 asm
  movl  sysnr,%eax
  pushl Param1
  call  actualsyscall
  addl  $4,%esp
 end;

function FpSysCall(sysnr,param1:integer):TSysResult; oldfpccall;assembler;[public,alias:'FPC_DOSYS1w'];

 asm
  movswl  sysnr,%eax
  pushw Param1
  call  actualsyscall
  add   $2,%esp
 end;

function FpSysCall(sysnr,param1,param2:TSysParam):TSysResult; oldfpccall;assembler; [public,alias:'FPC_DOSYS2'];

 asm
   movl  sysnr,%eax
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $8,%esp
 end;

function FpSysCall(sysnr,param1,param2,param3:TSysParam):TSysResult; oldfpccall;assembler;[public,alias:'FPC_DOSYS3'];

 asm
   movl  sysnr,%eax
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $12,%esp
end;

function FpSysCall(sysnr,param1,param2,param3,param4:TSysParam):TSysResult;oldfpccall; assembler;[public,alias:'FPC_DOSYS4'];

asm
   movl  sysnr,%eax
   pushl param4
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $16,%esp
end;


function FpSysCall(sysnr,param1,param2,param3,param4,param5:TSysParam):TSysResult;oldfpccall;  assembler;[public,alias:'FPC_DOSYS5'];

 asm
   movl  sysnr,%eax
   pushl param5
   pushl param4
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $20,%esp
end;

function FpSysCall(sysnr,param1,param2,param3,param4,param5,param6:TSysParam):int64; oldfpccall; assembler;[public,alias:'FPC_DOSYS6'];

asm
   movl  sysnr,%eax
   pushl param6
   pushl param5
   pushl param4
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $24,%esp
end;

function FpSysCall(sysnr,param1,param2,param3,param4,param5,param6,param7:TSysParam):int64;oldfpccall;  assembler; [public,alias:'FPC_DOSYS7'];

asm
   movl  sysnr,%eax
   pushl param7
   pushl param6
   pushl param5
   pushl param4
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $28,%esp
end;

function FpSysCall(sysnr,param1,param2,param3,param4,param5,param6,param7,param8:TSysParam):int64;oldfpccall;  assembler; [public,alias:'FPC_DOSYS8'];

asm
   movl  sysnr,%eax
   pushl param8
   pushl param7
   pushl param6
   pushl param5
   pushl param4
   pushl param3
   pushl param2
   pushl Param1
   call  actualsyscall
   addl  $32,%esp
end;

{$endif}
