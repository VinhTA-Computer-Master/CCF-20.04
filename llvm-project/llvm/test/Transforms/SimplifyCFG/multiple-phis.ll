; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -simplifycfg -simplifycfg-require-and-preserve-domtree=1 -keep-loops=false -S < %s | FileCheck %s
; RUN: opt -passes='simplify-cfg<no-keep-loops>' -S < %s | FileCheck %s

; It's not worthwhile to if-convert one of the phi nodes and leave
; the other behind, because that still requires a branch. If
; SimplifyCFG if-converts one of the phis, it should do both.

define i32 @upper_bound(i32* %r, i32 %high, i32 %k) nounwind {
; CHECK-LABEL: @upper_bound(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[WHILE_COND:%.*]]
; CHECK:       while.cond:
; CHECK-NEXT:    [[HIGH_ADDR_0:%.*]] = phi i32 [ [[HIGH:%.*]], [[ENTRY:%.*]] ], [ [[DIV_HIGH_ADDR_0:%.*]], [[WHILE_BODY:%.*]] ]
; CHECK-NEXT:    [[LOW_0:%.*]] = phi i32 [ 0, [[ENTRY]] ], [ [[LOW_0_ADD2:%.*]], [[WHILE_BODY]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp ult i32 [[LOW_0]], [[HIGH_ADDR_0]]
; CHECK-NEXT:    br i1 [[CMP]], label [[WHILE_BODY]], label [[WHILE_END:%.*]]
; CHECK:       while.body:
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[LOW_0]], [[HIGH_ADDR_0]]
; CHECK-NEXT:    [[DIV:%.*]] = udiv i32 [[ADD]], 2
; CHECK-NEXT:    [[IDXPROM:%.*]] = zext i32 [[DIV]] to i64
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds i32, i32* [[R:%.*]], i64 [[IDXPROM]]
; CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32* [[ARRAYIDX]]
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ult i32 [[K:%.*]], [[TMP0]]
; CHECK-NEXT:    [[ADD2:%.*]] = add i32 [[DIV]], 1
; CHECK-NEXT:    [[DIV_HIGH_ADDR_0]] = select i1 [[CMP1]], i32 [[DIV]], i32 [[HIGH_ADDR_0]]
; CHECK-NEXT:    [[LOW_0_ADD2]] = select i1 [[CMP1]], i32 [[LOW_0]], i32 [[ADD2]]
; CHECK-NEXT:    br label [[WHILE_COND]]
; CHECK:       while.end:
; CHECK-NEXT:    ret i32 [[LOW_0]]
;
entry:
  br label %while.cond

while.cond:                                       ; preds = %if.then, %if.else, %entry
  %high.addr.0 = phi i32 [ %high, %entry ], [ %div, %if.then ], [ %high.addr.0, %if.else ]
  %low.0 = phi i32 [ 0, %entry ], [ %low.0, %if.then ], [ %add2, %if.else ]
  %cmp = icmp ult i32 %low.0, %high.addr.0
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %add = add i32 %low.0, %high.addr.0
  %div = udiv i32 %add, 2
  %idxprom = zext i32 %div to i64
  %arrayidx = getelementptr inbounds i32, i32* %r, i64 %idxprom
  %0 = load i32, i32* %arrayidx
  %cmp1 = icmp ult i32 %k, %0
  br i1 %cmp1, label %if.then, label %if.else

if.then:                                          ; preds = %while.body
  br label %while.cond

if.else:                                          ; preds = %while.body
  %add2 = add i32 %div, 1
  br label %while.cond

while.end:                                        ; preds = %while.cond
  ret i32 %low.0
}