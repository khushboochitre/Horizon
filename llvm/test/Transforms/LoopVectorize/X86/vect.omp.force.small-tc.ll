; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -loop-vectorize -mcpu=corei7-avx -S -vectorizer-min-trip-count=21 | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux"

;
; The source code for the test:
;
; void foo(float* restrict A, float* restrict B)
; {
;     for (int i = 0; i < 20; ++i) A[i] += B[i];
; }
;

;
; This loop will be vectorized, although the trip count is below the threshold, but vectorization is explicitly forced in metadata.
;
define void @vectorized(float* noalias nocapture %A, float* noalias nocapture readonly %B) {
; CHECK-LABEL: @vectorized(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <8 x i64> undef, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <8 x i64> [[BROADCAST_SPLATINSERT]], <8 x i64> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <8 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds float, float* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[TMP2]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x float>, <8 x float>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[TMP5]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <8 x float>, <8 x float>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = fadd fast <8 x float> [[WIDE_LOAD]], [[WIDE_LOAD1]]
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP5]] to <8 x float>*
; CHECK-NEXT:    store <8 x float> [[TMP7]], <8 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 16
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !1
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 20, 16
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 16, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP10:%.*]] = load float, float* [[ARRAYIDX]], align 4, !llvm.access.group !0
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP11:%.*]] = load float, float* [[ARRAYIDX2]], align 4, !llvm.access.group !0
; CHECK-NEXT:    [[ADD:%.*]] = fadd fast float [[TMP10]], [[TMP11]]
; CHECK-NEXT:    store float [[ADD]], float* [[ARRAYIDX2]], align 4, !llvm.access.group !0
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 20
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !4
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %B, i64 %indvars.iv
  %0 = load float, float* %arrayidx, align 4, !llvm.access.group !11
  %arrayidx2 = getelementptr inbounds float, float* %A, i64 %indvars.iv
  %1 = load float, float* %arrayidx2, align 4, !llvm.access.group !11
  %add = fadd fast float %0, %1
  store float %add, float* %arrayidx2, align 4, !llvm.access.group !11
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 20
  br i1 %exitcond, label %for.end, label %for.body, !llvm.loop !1

for.end:
  ret void
}

!1 = !{!1, !2, !{!"llvm.loop.parallel_accesses", !11}}
!2 = !{!"llvm.loop.vectorize.enable", i1 true}
!11 = distinct !{}

;
; This loop will be vectorized as the trip count is below the threshold but no
; scalar iterations are needed thanks to folding its tail.
;
define void @vectorized1(float* noalias nocapture %A, float* noalias nocapture readonly %B) {
; CHECK-LABEL: @vectorized1(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <8 x i64> undef, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <8 x i64> [[BROADCAST_SPLATINSERT]], <8 x i64> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <8 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ule <8 x i64> [[INDUCTION]], <i64 19, i64 19, i64 19, i64 19, i64 19, i64 19, i64 19, i64 19>
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds float, float* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast float* [[TMP3]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD:%.*]] = call <8 x float> @llvm.masked.load.v8f32.p0v8f32(<8 x float>* [[TMP4]], i32 4, <8 x i1> [[TMP2]], <8 x float> undef), !llvm.access.group !6
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP6:%.*]] = getelementptr inbounds float, float* [[TMP5]], i32 0
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast float* [[TMP6]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_MASKED_LOAD1:%.*]] = call <8 x float> @llvm.masked.load.v8f32.p0v8f32(<8 x float>* [[TMP7]], i32 4, <8 x i1> [[TMP2]], <8 x float> undef), !llvm.access.group !6
; CHECK-NEXT:    [[TMP8:%.*]] = fadd fast <8 x float> [[WIDE_MASKED_LOAD]], [[WIDE_MASKED_LOAD1]]
; CHECK-NEXT:    [[TMP9:%.*]] = bitcast float* [[TMP6]] to <8 x float>*
; CHECK-NEXT:    call void @llvm.masked.store.v8f32.p0v8f32(<8 x float> [[TMP8]], <8 x float>* [[TMP9]], i32 4, <8 x i1> [[TMP2]])
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP10:%.*]] = icmp eq i64 [[INDEX_NEXT]], 24
; CHECK-NEXT:    br i1 [[TMP10]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !7
; CHECK:       middle.block:
; CHECK-NEXT:    br i1 true, label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %B, i64 %indvars.iv
  %0 = load float, float* %arrayidx, align 4, !llvm.access.group !13
  %arrayidx2 = getelementptr inbounds float, float* %A, i64 %indvars.iv
  %1 = load float, float* %arrayidx2, align 4, !llvm.access.group !13
  %add = fadd fast float %0, %1
  store float %add, float* %arrayidx2, align 4, !llvm.access.group !13
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 20
  br i1 %exitcond, label %for.end, label %for.body, !llvm.loop !3

for.end:
  ret void
}

!3 = !{!3, !{!"llvm.loop.parallel_accesses", !13}}
!13 = distinct !{}

;
; This loop will be vectorized as the trip count is below the threshold but no
; scalar iterations are needed.
;
define void @vectorized2(float* noalias nocapture %A, float* noalias nocapture readonly %B) {
; CHECK-LABEL: @vectorized2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 false, label [[SCALAR_PH:%.*]], label [[VECTOR_PH:%.*]]
; CHECK:       vector.ph:
; CHECK-NEXT:    br label [[VECTOR_BODY:%.*]]
; CHECK:       vector.body:
; CHECK-NEXT:    [[INDEX:%.*]] = phi i64 [ 0, [[VECTOR_PH]] ], [ [[INDEX_NEXT:%.*]], [[VECTOR_BODY]] ]
; CHECK-NEXT:    [[BROADCAST_SPLATINSERT:%.*]] = insertelement <8 x i64> undef, i64 [[INDEX]], i32 0
; CHECK-NEXT:    [[BROADCAST_SPLAT:%.*]] = shufflevector <8 x i64> [[BROADCAST_SPLATINSERT]], <8 x i64> undef, <8 x i32> zeroinitializer
; CHECK-NEXT:    [[INDUCTION:%.*]] = add <8 x i64> [[BROADCAST_SPLAT]], <i64 0, i64 1, i64 2, i64 3, i64 4, i64 5, i64 6, i64 7>
; CHECK-NEXT:    [[TMP0:%.*]] = add i64 [[INDEX]], 0
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds float, float* [[B:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds float, float* [[TMP1]], i32 0
; CHECK-NEXT:    [[TMP3:%.*]] = bitcast float* [[TMP2]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_LOAD:%.*]] = load <8 x float>, <8 x float>* [[TMP3]], align 4
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds float, float* [[A:%.*]], i64 [[TMP0]]
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds float, float* [[TMP4]], i32 0
; CHECK-NEXT:    [[TMP6:%.*]] = bitcast float* [[TMP5]] to <8 x float>*
; CHECK-NEXT:    [[WIDE_LOAD1:%.*]] = load <8 x float>, <8 x float>* [[TMP6]], align 4
; CHECK-NEXT:    [[TMP7:%.*]] = fadd fast <8 x float> [[WIDE_LOAD]], [[WIDE_LOAD1]]
; CHECK-NEXT:    [[TMP8:%.*]] = bitcast float* [[TMP5]] to <8 x float>*
; CHECK-NEXT:    store <8 x float> [[TMP7]], <8 x float>* [[TMP8]], align 4
; CHECK-NEXT:    [[INDEX_NEXT]] = add i64 [[INDEX]], 8
; CHECK-NEXT:    [[TMP9:%.*]] = icmp eq i64 [[INDEX_NEXT]], 16
; CHECK-NEXT:    br i1 [[TMP9]], label [[MIDDLE_BLOCK:%.*]], label [[VECTOR_BODY]], !llvm.loop !10
; CHECK:       middle.block:
; CHECK-NEXT:    [[CMP_N:%.*]] = icmp eq i64 16, 16
; CHECK-NEXT:    br i1 [[CMP_N]], label [[FOR_END:%.*]], label [[SCALAR_PH]]
; CHECK:       scalar.ph:
; CHECK-NEXT:    [[BC_RESUME_VAL:%.*]] = phi i64 [ 16, [[MIDDLE_BLOCK]] ], [ 0, [[ENTRY:%.*]] ]
; CHECK-NEXT:    br label [[FOR_BODY:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    [[INDVARS_IV:%.*]] = phi i64 [ [[BC_RESUME_VAL]], [[SCALAR_PH]] ], [ [[INDVARS_IV_NEXT:%.*]], [[FOR_BODY]] ]
; CHECK-NEXT:    [[ARRAYIDX:%.*]] = getelementptr inbounds float, float* [[B]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP10:%.*]] = load float, float* [[ARRAYIDX]], align 4, !llvm.access.group !6
; CHECK-NEXT:    [[ARRAYIDX2:%.*]] = getelementptr inbounds float, float* [[A]], i64 [[INDVARS_IV]]
; CHECK-NEXT:    [[TMP11:%.*]] = load float, float* [[ARRAYIDX2]], align 4, !llvm.access.group !6
; CHECK-NEXT:    [[ADD:%.*]] = fadd fast float [[TMP10]], [[TMP11]]
; CHECK-NEXT:    store float [[ADD]], float* [[ARRAYIDX2]], align 4, !llvm.access.group !6
; CHECK-NEXT:    [[INDVARS_IV_NEXT]] = add nuw nsw i64 [[INDVARS_IV]], 1
; CHECK-NEXT:    [[EXITCOND:%.*]] = icmp eq i64 [[INDVARS_IV_NEXT]], 16
; CHECK-NEXT:    br i1 [[EXITCOND]], label [[FOR_END]], label [[FOR_BODY]], !llvm.loop !11
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.body

for.body:
  %indvars.iv = phi i64 [ 0, %entry ], [ %indvars.iv.next, %for.body ]
  %arrayidx = getelementptr inbounds float, float* %B, i64 %indvars.iv
  %0 = load float, float* %arrayidx, align 4, !llvm.access.group !13
  %arrayidx2 = getelementptr inbounds float, float* %A, i64 %indvars.iv
  %1 = load float, float* %arrayidx2, align 4, !llvm.access.group !13
  %add = fadd fast float %0, %1
  store float %add, float* %arrayidx2, align 4, !llvm.access.group !13
  %indvars.iv.next = add nuw nsw i64 %indvars.iv, 1
  %exitcond = icmp eq i64 %indvars.iv.next, 16
  br i1 %exitcond, label %for.end, label %for.body, !llvm.loop !4

for.end:
  ret void
}

!4 = !{!4}

