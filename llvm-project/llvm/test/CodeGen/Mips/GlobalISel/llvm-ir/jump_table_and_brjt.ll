; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32
; RUN: llc  -O0 -mtriple=mipsel-linux-gnu -global-isel -relocation-model=pic -verify-machineinstrs %s -o -| FileCheck %s -check-prefixes=MIPS32_PIC

define i32 @mod4_0_to_11(i32 %a) {
; MIPS32-LABEL: mod4_0_to_11:
; MIPS32:       # %bb.0: # %entry
; MIPS32-NEXT:    addiu $sp, $sp, -32
; MIPS32-NEXT:    .cfi_def_cfa_offset 32
; MIPS32-NEXT:    sw $4, 4($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    ori $1, $zero, 7
; MIPS32-NEXT:    ori $2, $zero, 3
; MIPS32-NEXT:    sw $2, 8($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    ori $2, $zero, 2
; MIPS32-NEXT:    sw $2, 12($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    ori $2, $zero, 1
; MIPS32-NEXT:    sw $2, 16($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    ori $2, $zero, 0
; MIPS32-NEXT:    sw $2, 20($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    addiu $2, $zero, 65535
; MIPS32-NEXT:    sw $2, 24($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    ori $2, $zero, 0
; MIPS32-NEXT:    subu $2, $4, $2
; MIPS32-NEXT:    sw $2, 28($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sltu $1, $1, $2
; MIPS32-NEXT:    andi $1, $1, 1
; MIPS32-NEXT:    bnez $1, $BB0_6
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_1: # %entry
; MIPS32-NEXT:    lw $2, 28($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lui $1, %hi($JTI0_0)
; MIPS32-NEXT:    sll $2, $2, 2
; MIPS32-NEXT:    addu $1, $1, $2
; MIPS32-NEXT:    lw $1, %lo($JTI0_0)($1)
; MIPS32-NEXT:    jr $1
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_2: # %sw.bb
; MIPS32-NEXT:    lw $2, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_3: # %sw.bb1
; MIPS32-NEXT:    lw $2, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_4: # %sw.bb2
; MIPS32-NEXT:    lw $2, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_5: # %sw.bb3
; MIPS32-NEXT:    lw $2, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_6: # %sw.default
; MIPS32-NEXT:    .insn
; MIPS32-NEXT:  # %bb.7: # %sw.epilog
; MIPS32-NEXT:    lw $1, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lw $2, 4($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    ori $3, $zero, 8
; MIPS32-NEXT:    subu $2, $2, $3
; MIPS32-NEXT:    sw $2, 0($sp) # 4-byte Folded Spill
; MIPS32-NEXT:    sltu $1, $1, $2
; MIPS32-NEXT:    andi $1, $1, 1
; MIPS32-NEXT:    bnez $1, $BB0_13
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_8: # %sw.epilog
; MIPS32-NEXT:    lw $2, 0($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    lui $1, %hi($JTI0_1)
; MIPS32-NEXT:    sll $2, $2, 2
; MIPS32-NEXT:    addu $1, $1, $2
; MIPS32-NEXT:    lw $1, %lo($JTI0_1)($1)
; MIPS32-NEXT:    jr $1
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_9: # %sw.bb4
; MIPS32-NEXT:    lw $2, 20($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_10: # %sw.bb5
; MIPS32-NEXT:    lw $2, 16($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_11: # %sw.bb6
; MIPS32-NEXT:    lw $2, 12($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_12: # %sw.bb7
; MIPS32-NEXT:    lw $2, 8($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
; MIPS32-NEXT:  $BB0_13: # %sw.default8
; MIPS32-NEXT:    lw $2, 24($sp) # 4-byte Folded Reload
; MIPS32-NEXT:    addiu $sp, $sp, 32
; MIPS32-NEXT:    jr $ra
; MIPS32-NEXT:    nop
;
; MIPS32_PIC-LABEL: mod4_0_to_11:
; MIPS32_PIC:       # %bb.0: # %entry
; MIPS32_PIC-NEXT:    lui $2, %hi(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $2, $2, %lo(_gp_disp)
; MIPS32_PIC-NEXT:    addiu $sp, $sp, -40
; MIPS32_PIC-NEXT:    .cfi_def_cfa_offset 40
; MIPS32_PIC-NEXT:    addu $1, $2, $25
; MIPS32_PIC-NEXT:    sw $1, 8($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    sw $4, 12($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    ori $1, $zero, 7
; MIPS32_PIC-NEXT:    ori $2, $zero, 3
; MIPS32_PIC-NEXT:    sw $2, 16($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    ori $2, $zero, 2
; MIPS32_PIC-NEXT:    sw $2, 20($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    ori $2, $zero, 1
; MIPS32_PIC-NEXT:    sw $2, 24($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    ori $2, $zero, 0
; MIPS32_PIC-NEXT:    sw $2, 28($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    addiu $2, $zero, 65535
; MIPS32_PIC-NEXT:    sw $2, 32($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    ori $2, $zero, 0
; MIPS32_PIC-NEXT:    subu $2, $4, $2
; MIPS32_PIC-NEXT:    sw $2, 36($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    sltu $1, $1, $2
; MIPS32_PIC-NEXT:    andi $1, $1, 1
; MIPS32_PIC-NEXT:    bnez $1, $BB0_6
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_1: # %entry
; MIPS32_PIC-NEXT:    lw $2, 8($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    lw $3, 36($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    lw $1, %got($JTI0_0)($2)
; MIPS32_PIC-NEXT:    sll $3, $3, 2
; MIPS32_PIC-NEXT:    addu $1, $1, $3
; MIPS32_PIC-NEXT:    lw $1, %lo($JTI0_0)($1)
; MIPS32_PIC-NEXT:    addu $1, $1, $2
; MIPS32_PIC-NEXT:    jr $1
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_2: # %sw.bb
; MIPS32_PIC-NEXT:    lw $2, 28($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_3: # %sw.bb1
; MIPS32_PIC-NEXT:    lw $2, 24($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_4: # %sw.bb2
; MIPS32_PIC-NEXT:    lw $2, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_5: # %sw.bb3
; MIPS32_PIC-NEXT:    lw $2, 16($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_6: # %sw.default
; MIPS32_PIC-NEXT:    .insn
; MIPS32_PIC-NEXT:  # %bb.7: # %sw.epilog
; MIPS32_PIC-NEXT:    lw $1, 16($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    lw $2, 12($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    ori $3, $zero, 8
; MIPS32_PIC-NEXT:    subu $2, $2, $3
; MIPS32_PIC-NEXT:    sw $2, 4($sp) # 4-byte Folded Spill
; MIPS32_PIC-NEXT:    sltu $1, $1, $2
; MIPS32_PIC-NEXT:    andi $1, $1, 1
; MIPS32_PIC-NEXT:    bnez $1, $BB0_13
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_8: # %sw.epilog
; MIPS32_PIC-NEXT:    lw $2, 8($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    lw $3, 4($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    lw $1, %got($JTI0_1)($2)
; MIPS32_PIC-NEXT:    sll $3, $3, 2
; MIPS32_PIC-NEXT:    addu $1, $1, $3
; MIPS32_PIC-NEXT:    lw $1, %lo($JTI0_1)($1)
; MIPS32_PIC-NEXT:    addu $1, $1, $2
; MIPS32_PIC-NEXT:    jr $1
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_9: # %sw.bb4
; MIPS32_PIC-NEXT:    lw $2, 28($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_10: # %sw.bb5
; MIPS32_PIC-NEXT:    lw $2, 24($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_11: # %sw.bb6
; MIPS32_PIC-NEXT:    lw $2, 20($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_12: # %sw.bb7
; MIPS32_PIC-NEXT:    lw $2, 16($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop
; MIPS32_PIC-NEXT:  $BB0_13: # %sw.default8
; MIPS32_PIC-NEXT:    lw $2, 32($sp) # 4-byte Folded Reload
; MIPS32_PIC-NEXT:    addiu $sp, $sp, 40
; MIPS32_PIC-NEXT:    jr $ra
; MIPS32_PIC-NEXT:    nop


entry:
  switch i32 %a, label %sw.default [
    i32 0, label %sw.bb
    i32 4, label %sw.bb
    i32 1, label %sw.bb1
    i32 5, label %sw.bb1
    i32 2, label %sw.bb2
    i32 6, label %sw.bb2
    i32 3, label %sw.bb3
    i32 7, label %sw.bb3
  ]

sw.bb:                                            ; preds = %entry, %entry
  ret i32 0

sw.bb1:                                           ; preds = %entry, %entry
  ret i32 1

sw.bb2:                                           ; preds = %entry, %entry
  ret i32 2

sw.bb3:                                           ; preds = %entry, %entry
  ret i32 3

sw.default:                                       ; preds = %entry
  br label %sw.epilog

sw.epilog:                                        ; preds = %sw.default
  switch i32 %a, label %sw.default8 [
    i32 8, label %sw.bb4
    i32 9, label %sw.bb5
    i32 10, label %sw.bb6
    i32 11, label %sw.bb7
  ]

sw.bb4:                                           ; preds = %sw.epilog
  ret i32 0

sw.bb5:                                           ; preds = %sw.epilog
  ret i32 1

sw.bb6:                                           ; preds = %sw.epilog
  ret i32 2

sw.bb7:                                           ; preds = %sw.epilog
  ret i32 3

sw.default8:                                      ; preds = %sw.epilog
  ret i32 -1

}