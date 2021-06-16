; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-LIN
; RUN: llc < %s -mtriple=x86_64-pc-windows-msvc   -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-WIN
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512dq,+avx512vl | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-LIN
; RUN: llc < %s -mtriple=x86_64-pc-windows-msvc   -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-WIN
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f,+avx512dq | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+avx512f | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+avx512f | FileCheck %s --check-prefixes=X86-AVX512,X86-AVX512-LIN
; RUN: llc < %s -mtriple=x86_64-pc-windows-msvc   -mattr=+avx512f | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-WIN
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+avx512f | FileCheck %s --check-prefixes=X64-AVX512,X64-AVX512-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+sse3 | FileCheck %s --check-prefixes=X86-SSE,X86-SSE3,X86-SSE-WIN,X86-SSE3-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+sse3 | FileCheck %s --check-prefixes=X86-SSE,X86-SSE3,X86-SSE-LIN,X86-SSE3-LIN
; RUN: llc < %s -mtriple=x86_64-pc-windows-msvc   -mattr=+sse3 | FileCheck %s --check-prefixes=X64-SSE,X64-SSE-WIN,X64-SSE3-WIN
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+sse3 | FileCheck %s --check-prefixes=X64-SSE,X64-SSE-LIN,X64-SSE3-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+sse2 | FileCheck %s --check-prefixes=X86-SSE,X86-SSE2,X86-SSE-WIN,X86-SSE2-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+sse2 | FileCheck %s --check-prefixes=X86-SSE,X86-SSE2,X86-SSE-LIN,X86-SSE2-LIN
; RUN: llc < %s -mtriple=x86_64-pc-windows-msvc   -mattr=+sse2 | FileCheck %s --check-prefixes=X64-SSE,X64-SSE-WIN,X64-SSE2-WIN
; RUN: llc < %s -mtriple=x86_64-unknown-linux-gnu -mattr=+sse2 | FileCheck %s --check-prefixes=X64-SSE,X64-SSE-LIN,X64-SSE2-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=+sse  | FileCheck %s --check-prefixes=X86-SSE,X86-SSE1,X86-SSE-WIN,X86-SSE1-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=+sse  | FileCheck %s --check-prefixes=X86-SSE,X86-SSE1,X86-SSE-LIN,X86-SSE1-LIN
; RUN: llc < %s -mtriple=i386-pc-windows-msvc     -mattr=-sse  | FileCheck %s --check-prefixes=X87,X87-WIN
; RUN: llc < %s -mtriple=i386-unknown-linux-gnu   -mattr=-sse  | FileCheck %s --check-prefixes=X87,X87-LIN

; Check that scalar FP conversions to signed and unsigned int32 are using
; reasonable sequences, across platforms and target switches.

define i32 @f_to_u32(float %a) nounwind {
; X86-AVX512-LABEL: f_to_u32:
; X86-AVX512:       # %bb.0:
; X86-AVX512-NEXT:    vcvttss2usi {{[0-9]+}}(%esp), %eax
; X86-AVX512-NEXT:    retl
;
; X64-AVX512-LABEL: f_to_u32:
; X64-AVX512:       # %bb.0:
; X64-AVX512-NEXT:    vcvttss2usi %xmm0, %eax
; X64-AVX512-NEXT:    retq
;
; X86-SSE3-WIN-LABEL: f_to_u32:
; X86-SSE3-WIN:       # %bb.0:
; X86-SSE3-WIN-NEXT:    pushl %ebp
; X86-SSE3-WIN-NEXT:    movl %esp, %ebp
; X86-SSE3-WIN-NEXT:    andl $-8, %esp
; X86-SSE3-WIN-NEXT:    subl $8, %esp
; X86-SSE3-WIN-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE3-WIN-NEXT:    movss %xmm0, (%esp)
; X86-SSE3-WIN-NEXT:    flds (%esp)
; X86-SSE3-WIN-NEXT:    fisttpll (%esp)
; X86-SSE3-WIN-NEXT:    movl (%esp), %eax
; X86-SSE3-WIN-NEXT:    movl %ebp, %esp
; X86-SSE3-WIN-NEXT:    popl %ebp
; X86-SSE3-WIN-NEXT:    retl
;
; X86-SSE3-LIN-LABEL: f_to_u32:
; X86-SSE3-LIN:       # %bb.0:
; X86-SSE3-LIN-NEXT:    subl $12, %esp
; X86-SSE3-LIN-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE3-LIN-NEXT:    movss %xmm0, (%esp)
; X86-SSE3-LIN-NEXT:    flds (%esp)
; X86-SSE3-LIN-NEXT:    fisttpll (%esp)
; X86-SSE3-LIN-NEXT:    movl (%esp), %eax
; X86-SSE3-LIN-NEXT:    addl $12, %esp
; X86-SSE3-LIN-NEXT:    retl
;
; X64-SSE-LABEL: f_to_u32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvttss2si %xmm0, %rax
; X64-SSE-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-SSE-NEXT:    retq
;
; X86-SSE2-LABEL: f_to_u32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE2-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-SSE2-NEXT:    movaps %xmm0, %xmm2
; X86-SSE2-NEXT:    subss %xmm1, %xmm2
; X86-SSE2-NEXT:    cvttss2si %xmm2, %ecx
; X86-SSE2-NEXT:    xorl $-2147483648, %ecx # imm = 0x80000000
; X86-SSE2-NEXT:    cvttss2si %xmm0, %eax
; X86-SSE2-NEXT:    ucomiss %xmm0, %xmm1
; X86-SSE2-NEXT:    cmovbel %ecx, %eax
; X86-SSE2-NEXT:    retl
;
; X86-SSE1-LABEL: f_to_u32:
; X86-SSE1:       # %bb.0:
; X86-SSE1-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; X86-SSE1-NEXT:    movss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; X86-SSE1-NEXT:    movaps %xmm0, %xmm2
; X86-SSE1-NEXT:    subss %xmm1, %xmm2
; X86-SSE1-NEXT:    cvttss2si %xmm2, %ecx
; X86-SSE1-NEXT:    xorl $-2147483648, %ecx # imm = 0x80000000
; X86-SSE1-NEXT:    cvttss2si %xmm0, %eax
; X86-SSE1-NEXT:    ucomiss %xmm0, %xmm1
; X86-SSE1-NEXT:    cmovbel %ecx, %eax
; X86-SSE1-NEXT:    retl
;
; X87-WIN-LABEL: f_to_u32:
; X87-WIN:       # %bb.0:
; X87-WIN-NEXT:    pushl %ebp
; X87-WIN-NEXT:    movl %esp, %ebp
; X87-WIN-NEXT:    andl $-8, %esp
; X87-WIN-NEXT:    subl $16, %esp
; X87-WIN-NEXT:    flds 8(%ebp)
; X87-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    movl %ebp, %esp
; X87-WIN-NEXT:    popl %ebp
; X87-WIN-NEXT:    retl
;
; X87-LIN-LABEL: f_to_u32:
; X87-LIN:       # %bb.0:
; X87-LIN-NEXT:    subl $20, %esp
; X87-LIN-NEXT:    flds {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    addl $20, %esp
; X87-LIN-NEXT:    retl
  %r = fptoui float %a to i32
  ret i32 %r
}

define i32 @f_to_s32(float %a) nounwind {
; X86-AVX512-LABEL: f_to_s32:
; X86-AVX512:       # %bb.0:
; X86-AVX512-NEXT:    vcvttss2si {{[0-9]+}}(%esp), %eax
; X86-AVX512-NEXT:    retl
;
; X64-AVX512-LABEL: f_to_s32:
; X64-AVX512:       # %bb.0:
; X64-AVX512-NEXT:    vcvttss2si %xmm0, %eax
; X64-AVX512-NEXT:    retq
;
; X86-SSE-LABEL: f_to_s32:
; X86-SSE:       # %bb.0:
; X86-SSE-NEXT:    cvttss2si {{[0-9]+}}(%esp), %eax
; X86-SSE-NEXT:    retl
;
; X64-SSE-LABEL: f_to_s32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvttss2si %xmm0, %eax
; X64-SSE-NEXT:    retq
;
; X87-LABEL: f_to_s32:
; X87:       # %bb.0:
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    flds {{[0-9]+}}(%esp)
; X87-NEXT:    fnstcw (%esp)
; X87-NEXT:    movzwl (%esp), %eax
; X87-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-NEXT:    fistpl {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw (%esp)
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    addl $8, %esp
; X87-NEXT:    retl
  %r = fptosi float %a to i32
  ret i32 %r
}

define i32 @d_to_u32(double %a) nounwind {
; X86-AVX512-LABEL: d_to_u32:
; X86-AVX512:       # %bb.0:
; X86-AVX512-NEXT:    vcvttsd2usi {{[0-9]+}}(%esp), %eax
; X86-AVX512-NEXT:    retl
;
; X64-AVX512-LABEL: d_to_u32:
; X64-AVX512:       # %bb.0:
; X64-AVX512-NEXT:    vcvttsd2usi %xmm0, %eax
; X64-AVX512-NEXT:    retq
;
; X86-SSE3-WIN-LABEL: d_to_u32:
; X86-SSE3-WIN:       # %bb.0:
; X86-SSE3-WIN-NEXT:    pushl %ebp
; X86-SSE3-WIN-NEXT:    movl %esp, %ebp
; X86-SSE3-WIN-NEXT:    andl $-8, %esp
; X86-SSE3-WIN-NEXT:    subl $8, %esp
; X86-SSE3-WIN-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-SSE3-WIN-NEXT:    movsd %xmm0, (%esp)
; X86-SSE3-WIN-NEXT:    fldl (%esp)
; X86-SSE3-WIN-NEXT:    fisttpll (%esp)
; X86-SSE3-WIN-NEXT:    movl (%esp), %eax
; X86-SSE3-WIN-NEXT:    movl %ebp, %esp
; X86-SSE3-WIN-NEXT:    popl %ebp
; X86-SSE3-WIN-NEXT:    retl
;
; X86-SSE3-LIN-LABEL: d_to_u32:
; X86-SSE3-LIN:       # %bb.0:
; X86-SSE3-LIN-NEXT:    subl $12, %esp
; X86-SSE3-LIN-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-SSE3-LIN-NEXT:    movsd %xmm0, (%esp)
; X86-SSE3-LIN-NEXT:    fldl (%esp)
; X86-SSE3-LIN-NEXT:    fisttpll (%esp)
; X86-SSE3-LIN-NEXT:    movl (%esp), %eax
; X86-SSE3-LIN-NEXT:    addl $12, %esp
; X86-SSE3-LIN-NEXT:    retl
;
; X64-SSE-LABEL: d_to_u32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvttsd2si %xmm0, %rax
; X64-SSE-NEXT:    # kill: def $eax killed $eax killed $rax
; X64-SSE-NEXT:    retq
;
; X86-SSE2-LABEL: d_to_u32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    movsd {{.*#+}} xmm0 = mem[0],zero
; X86-SSE2-NEXT:    movsd {{.*#+}} xmm1 = mem[0],zero
; X86-SSE2-NEXT:    movapd %xmm0, %xmm2
; X86-SSE2-NEXT:    subsd %xmm1, %xmm2
; X86-SSE2-NEXT:    cvttsd2si %xmm2, %ecx
; X86-SSE2-NEXT:    xorl $-2147483648, %ecx # imm = 0x80000000
; X86-SSE2-NEXT:    cvttsd2si %xmm0, %eax
; X86-SSE2-NEXT:    ucomisd %xmm0, %xmm1
; X86-SSE2-NEXT:    cmovbel %ecx, %eax
; X86-SSE2-NEXT:    retl
;
; X86-SSE1-WIN-LABEL: d_to_u32:
; X86-SSE1-WIN:       # %bb.0:
; X86-SSE1-WIN-NEXT:    pushl %ebp
; X86-SSE1-WIN-NEXT:    movl %esp, %ebp
; X86-SSE1-WIN-NEXT:    andl $-8, %esp
; X86-SSE1-WIN-NEXT:    subl $16, %esp
; X86-SSE1-WIN-NEXT:    fldl 8(%ebp)
; X86-SSE1-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE1-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-WIN-NEXT:    movl %ebp, %esp
; X86-SSE1-WIN-NEXT:    popl %ebp
; X86-SSE1-WIN-NEXT:    retl
;
; X86-SSE1-LIN-LABEL: d_to_u32:
; X86-SSE1-LIN:       # %bb.0:
; X86-SSE1-LIN-NEXT:    subl $20, %esp
; X86-SSE1-LIN-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE1-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-LIN-NEXT:    addl $20, %esp
; X86-SSE1-LIN-NEXT:    retl
;
; X87-WIN-LABEL: d_to_u32:
; X87-WIN:       # %bb.0:
; X87-WIN-NEXT:    pushl %ebp
; X87-WIN-NEXT:    movl %esp, %ebp
; X87-WIN-NEXT:    andl $-8, %esp
; X87-WIN-NEXT:    subl $16, %esp
; X87-WIN-NEXT:    fldl 8(%ebp)
; X87-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    movl %ebp, %esp
; X87-WIN-NEXT:    popl %ebp
; X87-WIN-NEXT:    retl
;
; X87-LIN-LABEL: d_to_u32:
; X87-LIN:       # %bb.0:
; X87-LIN-NEXT:    subl $20, %esp
; X87-LIN-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    addl $20, %esp
; X87-LIN-NEXT:    retl
  %r = fptoui double %a to i32
  ret i32 %r
}

define i32 @d_to_s32(double %a) nounwind {
; X86-AVX512-LABEL: d_to_s32:
; X86-AVX512:       # %bb.0:
; X86-AVX512-NEXT:    vcvttsd2si {{[0-9]+}}(%esp), %eax
; X86-AVX512-NEXT:    retl
;
; X64-AVX512-LABEL: d_to_s32:
; X64-AVX512:       # %bb.0:
; X64-AVX512-NEXT:    vcvttsd2si %xmm0, %eax
; X64-AVX512-NEXT:    retq
;
; X86-SSE3-LABEL: d_to_s32:
; X86-SSE3:       # %bb.0:
; X86-SSE3-NEXT:    cvttsd2si {{[0-9]+}}(%esp), %eax
; X86-SSE3-NEXT:    retl
;
; X64-SSE-LABEL: d_to_s32:
; X64-SSE:       # %bb.0:
; X64-SSE-NEXT:    cvttsd2si %xmm0, %eax
; X64-SSE-NEXT:    retq
;
; X86-SSE2-LABEL: d_to_s32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    cvttsd2si {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    retl
;
; X86-SSE1-LABEL: d_to_s32:
; X86-SSE1:       # %bb.0:
; X86-SSE1-NEXT:    subl $8, %esp
; X86-SSE1-NEXT:    fldl {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fnstcw (%esp)
; X86-SSE1-NEXT:    movzwl (%esp), %eax
; X86-SSE1-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fistpl {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fldcw (%esp)
; X86-SSE1-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-NEXT:    addl $8, %esp
; X86-SSE1-NEXT:    retl
;
; X87-LABEL: d_to_s32:
; X87:       # %bb.0:
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    fldl {{[0-9]+}}(%esp)
; X87-NEXT:    fnstcw (%esp)
; X87-NEXT:    movzwl (%esp), %eax
; X87-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-NEXT:    fistpl {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw (%esp)
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    addl $8, %esp
; X87-NEXT:    retl
  %r = fptosi double %a to i32
  ret i32 %r
}

define i32 @x_to_u32(x86_fp80 %a) nounwind {
; X86-AVX512-WIN-LABEL: x_to_u32:
; X86-AVX512-WIN:       # %bb.0:
; X86-AVX512-WIN-NEXT:    pushl %ebp
; X86-AVX512-WIN-NEXT:    movl %esp, %ebp
; X86-AVX512-WIN-NEXT:    andl $-8, %esp
; X86-AVX512-WIN-NEXT:    subl $8, %esp
; X86-AVX512-WIN-NEXT:    fldt 8(%ebp)
; X86-AVX512-WIN-NEXT:    fisttpll (%esp)
; X86-AVX512-WIN-NEXT:    movl (%esp), %eax
; X86-AVX512-WIN-NEXT:    movl %ebp, %esp
; X86-AVX512-WIN-NEXT:    popl %ebp
; X86-AVX512-WIN-NEXT:    retl
;
; X86-AVX512-LIN-LABEL: x_to_u32:
; X86-AVX512-LIN:       # %bb.0:
; X86-AVX512-LIN-NEXT:    subl $12, %esp
; X86-AVX512-LIN-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-AVX512-LIN-NEXT:    fisttpll (%esp)
; X86-AVX512-LIN-NEXT:    movl (%esp), %eax
; X86-AVX512-LIN-NEXT:    addl $12, %esp
; X86-AVX512-LIN-NEXT:    retl
;
; X64-AVX512-WIN-LABEL: x_to_u32:
; X64-AVX512-WIN:       # %bb.0:
; X64-AVX512-WIN-NEXT:    pushq %rax
; X64-AVX512-WIN-NEXT:    fldt (%rcx)
; X64-AVX512-WIN-NEXT:    fisttpll (%rsp)
; X64-AVX512-WIN-NEXT:    movl (%rsp), %eax
; X64-AVX512-WIN-NEXT:    popq %rcx
; X64-AVX512-WIN-NEXT:    retq
;
; X64-AVX512-LIN-LABEL: x_to_u32:
; X64-AVX512-LIN:       # %bb.0:
; X64-AVX512-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-AVX512-LIN-NEXT:    fisttpll -{{[0-9]+}}(%rsp)
; X64-AVX512-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-AVX512-LIN-NEXT:    retq
;
; X86-SSE3-WIN-LABEL: x_to_u32:
; X86-SSE3-WIN:       # %bb.0:
; X86-SSE3-WIN-NEXT:    pushl %ebp
; X86-SSE3-WIN-NEXT:    movl %esp, %ebp
; X86-SSE3-WIN-NEXT:    andl $-8, %esp
; X86-SSE3-WIN-NEXT:    subl $8, %esp
; X86-SSE3-WIN-NEXT:    fldt 8(%ebp)
; X86-SSE3-WIN-NEXT:    fisttpll (%esp)
; X86-SSE3-WIN-NEXT:    movl (%esp), %eax
; X86-SSE3-WIN-NEXT:    movl %ebp, %esp
; X86-SSE3-WIN-NEXT:    popl %ebp
; X86-SSE3-WIN-NEXT:    retl
;
; X86-SSE3-LIN-LABEL: x_to_u32:
; X86-SSE3-LIN:       # %bb.0:
; X86-SSE3-LIN-NEXT:    subl $12, %esp
; X86-SSE3-LIN-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE3-LIN-NEXT:    fisttpll (%esp)
; X86-SSE3-LIN-NEXT:    movl (%esp), %eax
; X86-SSE3-LIN-NEXT:    addl $12, %esp
; X86-SSE3-LIN-NEXT:    retl
;
; X64-SSE3-WIN-LABEL: x_to_u32:
; X64-SSE3-WIN:       # %bb.0:
; X64-SSE3-WIN-NEXT:    pushq %rax
; X64-SSE3-WIN-NEXT:    fldt (%rcx)
; X64-SSE3-WIN-NEXT:    fisttpll (%rsp)
; X64-SSE3-WIN-NEXT:    movl (%rsp), %eax
; X64-SSE3-WIN-NEXT:    popq %rcx
; X64-SSE3-WIN-NEXT:    retq
;
; X64-SSE3-LIN-LABEL: x_to_u32:
; X64-SSE3-LIN:       # %bb.0:
; X64-SSE3-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-SSE3-LIN-NEXT:    fisttpll -{{[0-9]+}}(%rsp)
; X64-SSE3-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-SSE3-LIN-NEXT:    retq
;
; X86-SSE2-WIN-LABEL: x_to_u32:
; X86-SSE2-WIN:       # %bb.0:
; X86-SSE2-WIN-NEXT:    pushl %ebp
; X86-SSE2-WIN-NEXT:    movl %esp, %ebp
; X86-SSE2-WIN-NEXT:    andl $-8, %esp
; X86-SSE2-WIN-NEXT:    subl $16, %esp
; X86-SSE2-WIN-NEXT:    fldt 8(%ebp)
; X86-SSE2-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE2-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE2-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE2-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE2-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE2-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE2-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE2-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-WIN-NEXT:    movl %ebp, %esp
; X86-SSE2-WIN-NEXT:    popl %ebp
; X86-SSE2-WIN-NEXT:    retl
;
; X86-SSE2-LIN-LABEL: x_to_u32:
; X86-SSE2-LIN:       # %bb.0:
; X86-SSE2-LIN-NEXT:    subl $20, %esp
; X86-SSE2-LIN-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE2-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE2-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE2-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-LIN-NEXT:    addl $20, %esp
; X86-SSE2-LIN-NEXT:    retl
;
; X64-SSE2-WIN-LABEL: x_to_u32:
; X64-SSE2-WIN:       # %bb.0:
; X64-SSE2-WIN-NEXT:    subq $16, %rsp
; X64-SSE2-WIN-NEXT:    fldt (%rcx)
; X64-SSE2-WIN-NEXT:    fnstcw {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    movzwl {{[0-9]+}}(%rsp), %eax
; X64-SSE2-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X64-SSE2-WIN-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fldcw {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fistpll {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fldcw {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-SSE2-WIN-NEXT:    addq $16, %rsp
; X64-SSE2-WIN-NEXT:    retq
;
; X64-SSE2-LIN-LABEL: x_to_u32:
; X64-SSE2-LIN:       # %bb.0:
; X64-SSE2-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fnstcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; X64-SSE2-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X64-SSE2-LIN-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fistpll -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-SSE2-LIN-NEXT:    retq
;
; X86-SSE1-WIN-LABEL: x_to_u32:
; X86-SSE1-WIN:       # %bb.0:
; X86-SSE1-WIN-NEXT:    pushl %ebp
; X86-SSE1-WIN-NEXT:    movl %esp, %ebp
; X86-SSE1-WIN-NEXT:    andl $-8, %esp
; X86-SSE1-WIN-NEXT:    subl $16, %esp
; X86-SSE1-WIN-NEXT:    fldt 8(%ebp)
; X86-SSE1-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE1-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-WIN-NEXT:    movl %ebp, %esp
; X86-SSE1-WIN-NEXT:    popl %ebp
; X86-SSE1-WIN-NEXT:    retl
;
; X86-SSE1-LIN-LABEL: x_to_u32:
; X86-SSE1-LIN:       # %bb.0:
; X86-SSE1-LIN-NEXT:    subl $20, %esp
; X86-SSE1-LIN-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-SSE1-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-LIN-NEXT:    addl $20, %esp
; X86-SSE1-LIN-NEXT:    retl
;
; X87-WIN-LABEL: x_to_u32:
; X87-WIN:       # %bb.0:
; X87-WIN-NEXT:    pushl %ebp
; X87-WIN-NEXT:    movl %esp, %ebp
; X87-WIN-NEXT:    andl $-8, %esp
; X87-WIN-NEXT:    subl $16, %esp
; X87-WIN-NEXT:    fldt 8(%ebp)
; X87-WIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-WIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-WIN-NEXT:    movl %ebp, %esp
; X87-WIN-NEXT:    popl %ebp
; X87-WIN-NEXT:    retl
;
; X87-LIN-LABEL: x_to_u32:
; X87-LIN:       # %bb.0:
; X87-LIN-NEXT:    subl $20, %esp
; X87-LIN-NEXT:    fldt {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fnstcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-LIN-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fistpll {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-LIN-NEXT:    addl $20, %esp
; X87-LIN-NEXT:    retl
  %r = fptoui x86_fp80 %a to i32
  ret i32 %r
}

define i32 @x_to_s32(x86_fp80 %a) nounwind {
; X86-AVX512-LABEL: x_to_s32:
; X86-AVX512:       # %bb.0:
; X86-AVX512-NEXT:    pushl %eax
; X86-AVX512-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-AVX512-NEXT:    fisttpl (%esp)
; X86-AVX512-NEXT:    movl (%esp), %eax
; X86-AVX512-NEXT:    popl %ecx
; X86-AVX512-NEXT:    retl
;
; X64-AVX512-WIN-LABEL: x_to_s32:
; X64-AVX512-WIN:       # %bb.0:
; X64-AVX512-WIN-NEXT:    pushq %rax
; X64-AVX512-WIN-NEXT:    fldt (%rcx)
; X64-AVX512-WIN-NEXT:    fisttpl {{[0-9]+}}(%rsp)
; X64-AVX512-WIN-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-AVX512-WIN-NEXT:    popq %rcx
; X64-AVX512-WIN-NEXT:    retq
;
; X64-AVX512-LIN-LABEL: x_to_s32:
; X64-AVX512-LIN:       # %bb.0:
; X64-AVX512-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-AVX512-LIN-NEXT:    fisttpl -{{[0-9]+}}(%rsp)
; X64-AVX512-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-AVX512-LIN-NEXT:    retq
;
; X86-SSE3-LABEL: x_to_s32:
; X86-SSE3:       # %bb.0:
; X86-SSE3-NEXT:    pushl %eax
; X86-SSE3-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE3-NEXT:    fisttpl (%esp)
; X86-SSE3-NEXT:    movl (%esp), %eax
; X86-SSE3-NEXT:    popl %ecx
; X86-SSE3-NEXT:    retl
;
; X64-SSE3-WIN-LABEL: x_to_s32:
; X64-SSE3-WIN:       # %bb.0:
; X64-SSE3-WIN-NEXT:    pushq %rax
; X64-SSE3-WIN-NEXT:    fldt (%rcx)
; X64-SSE3-WIN-NEXT:    fisttpl {{[0-9]+}}(%rsp)
; X64-SSE3-WIN-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-SSE3-WIN-NEXT:    popq %rcx
; X64-SSE3-WIN-NEXT:    retq
;
; X64-SSE3-LIN-LABEL: x_to_s32:
; X64-SSE3-LIN:       # %bb.0:
; X64-SSE3-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-SSE3-LIN-NEXT:    fisttpl -{{[0-9]+}}(%rsp)
; X64-SSE3-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-SSE3-LIN-NEXT:    retq
;
; X86-SSE2-LABEL: x_to_s32:
; X86-SSE2:       # %bb.0:
; X86-SSE2-NEXT:    subl $8, %esp
; X86-SSE2-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE2-NEXT:    fnstcw (%esp)
; X86-SSE2-NEXT:    movzwl (%esp), %eax
; X86-SSE2-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE2-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE2-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE2-NEXT:    fistpl {{[0-9]+}}(%esp)
; X86-SSE2-NEXT:    fldcw (%esp)
; X86-SSE2-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE2-NEXT:    addl $8, %esp
; X86-SSE2-NEXT:    retl
;
; X64-SSE2-WIN-LABEL: x_to_s32:
; X64-SSE2-WIN:       # %bb.0:
; X64-SSE2-WIN-NEXT:    pushq %rax
; X64-SSE2-WIN-NEXT:    fldt (%rcx)
; X64-SSE2-WIN-NEXT:    fnstcw (%rsp)
; X64-SSE2-WIN-NEXT:    movzwl (%rsp), %eax
; X64-SSE2-WIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X64-SSE2-WIN-NEXT:    movw %ax, {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fldcw {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fistpl {{[0-9]+}}(%rsp)
; X64-SSE2-WIN-NEXT:    fldcw (%rsp)
; X64-SSE2-WIN-NEXT:    movl {{[0-9]+}}(%rsp), %eax
; X64-SSE2-WIN-NEXT:    popq %rcx
; X64-SSE2-WIN-NEXT:    retq
;
; X64-SSE2-LIN-LABEL: x_to_s32:
; X64-SSE2-LIN:       # %bb.0:
; X64-SSE2-LIN-NEXT:    fldt {{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fnstcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    movzwl -{{[0-9]+}}(%rsp), %eax
; X64-SSE2-LIN-NEXT:    orl $3072, %eax # imm = 0xC00
; X64-SSE2-LIN-NEXT:    movw %ax, -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fistpl -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    fldcw -{{[0-9]+}}(%rsp)
; X64-SSE2-LIN-NEXT:    movl -{{[0-9]+}}(%rsp), %eax
; X64-SSE2-LIN-NEXT:    retq
;
; X86-SSE1-LABEL: x_to_s32:
; X86-SSE1:       # %bb.0:
; X86-SSE1-NEXT:    subl $8, %esp
; X86-SSE1-NEXT:    fldt {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fnstcw (%esp)
; X86-SSE1-NEXT:    movzwl (%esp), %eax
; X86-SSE1-NEXT:    orl $3072, %eax # imm = 0xC00
; X86-SSE1-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fldcw {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fistpl {{[0-9]+}}(%esp)
; X86-SSE1-NEXT:    fldcw (%esp)
; X86-SSE1-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-SSE1-NEXT:    addl $8, %esp
; X86-SSE1-NEXT:    retl
;
; X87-LABEL: x_to_s32:
; X87:       # %bb.0:
; X87-NEXT:    subl $8, %esp
; X87-NEXT:    fldt {{[0-9]+}}(%esp)
; X87-NEXT:    fnstcw (%esp)
; X87-NEXT:    movzwl (%esp), %eax
; X87-NEXT:    orl $3072, %eax # imm = 0xC00
; X87-NEXT:    movw %ax, {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw {{[0-9]+}}(%esp)
; X87-NEXT:    fistpl {{[0-9]+}}(%esp)
; X87-NEXT:    fldcw (%esp)
; X87-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X87-NEXT:    addl $8, %esp
; X87-NEXT:    retl
  %r = fptosi x86_fp80 %a to i32
  ret i32 %r
}

define i32 @t_to_u32(fp128 %a) nounwind {
; X86-AVX512-WIN-LABEL: t_to_u32:
; X86-AVX512-WIN:       # %bb.0:
; X86-AVX512-WIN-NEXT:    subl $16, %esp
; X86-AVX512-WIN-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-AVX512-WIN-NEXT:    vmovups %xmm0, (%esp)
; X86-AVX512-WIN-NEXT:    calll ___fixunstfsi
; X86-AVX512-WIN-NEXT:    addl $16, %esp
; X86-AVX512-WIN-NEXT:    retl
;
; X86-AVX512-LIN-LABEL: t_to_u32:
; X86-AVX512-LIN:       # %bb.0:
; X86-AVX512-LIN-NEXT:    subl $28, %esp
; X86-AVX512-LIN-NEXT:    vmovaps {{[0-9]+}}(%esp), %xmm0
; X86-AVX512-LIN-NEXT:    vmovups %xmm0, (%esp)
; X86-AVX512-LIN-NEXT:    calll __fixunstfsi
; X86-AVX512-LIN-NEXT:    addl $28, %esp
; X86-AVX512-LIN-NEXT:    retl
;
; X64-AVX512-WIN-LABEL: t_to_u32:
; X64-AVX512-WIN:       # %bb.0:
; X64-AVX512-WIN-NEXT:    subq $40, %rsp
; X64-AVX512-WIN-NEXT:    callq __fixunstfsi
; X64-AVX512-WIN-NEXT:    addq $40, %rsp
; X64-AVX512-WIN-NEXT:    retq
;
; X64-AVX512-LIN-LABEL: t_to_u32:
; X64-AVX512-LIN:       # %bb.0:
; X64-AVX512-LIN-NEXT:    pushq %rax
; X64-AVX512-LIN-NEXT:    callq __fixunstfsi
; X64-AVX512-LIN-NEXT:    popq %rcx
; X64-AVX512-LIN-NEXT:    retq
;
; X86-SSE-WIN-LABEL: t_to_u32:
; X86-SSE-WIN:       # %bb.0:
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    calll ___fixunstfsi
; X86-SSE-WIN-NEXT:    addl $16, %esp
; X86-SSE-WIN-NEXT:    retl
;
; X86-SSE-LIN-LABEL: t_to_u32:
; X86-SSE-LIN:       # %bb.0:
; X86-SSE-LIN-NEXT:    subl $12, %esp
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    calll __fixunstfsi
; X86-SSE-LIN-NEXT:    addl $28, %esp
; X86-SSE-LIN-NEXT:    retl
;
; X64-SSE-WIN-LABEL: t_to_u32:
; X64-SSE-WIN:       # %bb.0:
; X64-SSE-WIN-NEXT:    subq $40, %rsp
; X64-SSE-WIN-NEXT:    callq __fixunstfsi
; X64-SSE-WIN-NEXT:    addq $40, %rsp
; X64-SSE-WIN-NEXT:    retq
;
; X64-SSE-LIN-LABEL: t_to_u32:
; X64-SSE-LIN:       # %bb.0:
; X64-SSE-LIN-NEXT:    pushq %rax
; X64-SSE-LIN-NEXT:    callq __fixunstfsi
; X64-SSE-LIN-NEXT:    popq %rcx
; X64-SSE-LIN-NEXT:    retq
;
; X87-WIN-LABEL: t_to_u32:
; X87-WIN:       # %bb.0:
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    calll ___fixunstfsi
; X87-WIN-NEXT:    addl $16, %esp
; X87-WIN-NEXT:    retl
;
; X87-LIN-LABEL: t_to_u32:
; X87-LIN:       # %bb.0:
; X87-LIN-NEXT:    subl $12, %esp
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    calll __fixunstfsi
; X87-LIN-NEXT:    addl $28, %esp
; X87-LIN-NEXT:    retl
  %r = fptoui fp128 %a to i32
  ret i32 %r
}

define i32 @t_to_s32(fp128 %a) nounwind {
; X86-AVX512-WIN-LABEL: t_to_s32:
; X86-AVX512-WIN:       # %bb.0:
; X86-AVX512-WIN-NEXT:    subl $16, %esp
; X86-AVX512-WIN-NEXT:    vmovups {{[0-9]+}}(%esp), %xmm0
; X86-AVX512-WIN-NEXT:    vmovups %xmm0, (%esp)
; X86-AVX512-WIN-NEXT:    calll ___fixtfsi
; X86-AVX512-WIN-NEXT:    addl $16, %esp
; X86-AVX512-WIN-NEXT:    retl
;
; X86-AVX512-LIN-LABEL: t_to_s32:
; X86-AVX512-LIN:       # %bb.0:
; X86-AVX512-LIN-NEXT:    subl $28, %esp
; X86-AVX512-LIN-NEXT:    vmovaps {{[0-9]+}}(%esp), %xmm0
; X86-AVX512-LIN-NEXT:    vmovups %xmm0, (%esp)
; X86-AVX512-LIN-NEXT:    calll __fixtfsi
; X86-AVX512-LIN-NEXT:    addl $28, %esp
; X86-AVX512-LIN-NEXT:    retl
;
; X64-AVX512-WIN-LABEL: t_to_s32:
; X64-AVX512-WIN:       # %bb.0:
; X64-AVX512-WIN-NEXT:    subq $40, %rsp
; X64-AVX512-WIN-NEXT:    callq __fixtfsi
; X64-AVX512-WIN-NEXT:    addq $40, %rsp
; X64-AVX512-WIN-NEXT:    retq
;
; X64-AVX512-LIN-LABEL: t_to_s32:
; X64-AVX512-LIN:       # %bb.0:
; X64-AVX512-LIN-NEXT:    pushq %rax
; X64-AVX512-LIN-NEXT:    callq __fixtfsi
; X64-AVX512-LIN-NEXT:    popq %rcx
; X64-AVX512-LIN-NEXT:    retq
;
; X86-SSE-WIN-LABEL: t_to_s32:
; X86-SSE-WIN:       # %bb.0:
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-WIN-NEXT:    calll ___fixtfsi
; X86-SSE-WIN-NEXT:    addl $16, %esp
; X86-SSE-WIN-NEXT:    retl
;
; X86-SSE-LIN-LABEL: t_to_s32:
; X86-SSE-LIN:       # %bb.0:
; X86-SSE-LIN-NEXT:    subl $12, %esp
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X86-SSE-LIN-NEXT:    calll __fixtfsi
; X86-SSE-LIN-NEXT:    addl $28, %esp
; X86-SSE-LIN-NEXT:    retl
;
; X64-SSE-WIN-LABEL: t_to_s32:
; X64-SSE-WIN:       # %bb.0:
; X64-SSE-WIN-NEXT:    subq $40, %rsp
; X64-SSE-WIN-NEXT:    callq __fixtfsi
; X64-SSE-WIN-NEXT:    addq $40, %rsp
; X64-SSE-WIN-NEXT:    retq
;
; X64-SSE-LIN-LABEL: t_to_s32:
; X64-SSE-LIN:       # %bb.0:
; X64-SSE-LIN-NEXT:    pushq %rax
; X64-SSE-LIN-NEXT:    callq __fixtfsi
; X64-SSE-LIN-NEXT:    popq %rcx
; X64-SSE-LIN-NEXT:    retq
;
; X87-WIN-LABEL: t_to_s32:
; X87-WIN:       # %bb.0:
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-WIN-NEXT:    calll ___fixtfsi
; X87-WIN-NEXT:    addl $16, %esp
; X87-WIN-NEXT:    retl
;
; X87-LIN-LABEL: t_to_s32:
; X87-LIN:       # %bb.0:
; X87-LIN-NEXT:    subl $12, %esp
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    pushl {{[0-9]+}}(%esp)
; X87-LIN-NEXT:    calll __fixtfsi
; X87-LIN-NEXT:    addl $28, %esp
; X87-LIN-NEXT:    retl
  %r = fptosi fp128 %a to i32
  ret i32 %r
}