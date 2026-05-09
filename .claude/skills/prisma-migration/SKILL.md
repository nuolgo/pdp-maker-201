---
name: prisma-migration
description: Use when modifying apps/api/prisma/schema.prisma — covers migration creation, client regeneration, and verification steps
---

# Prisma 스키마 변경 절차

## 관련 파일
- `apps/api/prisma/schema.prisma` — 단일 스키마
- `apps/api/prisma/migrations/` — 마이그레이션 SQL
- `apps/api/src/prisma/prisma.service.ts` — 클라이언트 래퍼

## 표준 절차

### 1. 스키마 수정
`schema.prisma`에서 모델/필드 변경

### 2. 마이그레이션 생성 (개발 DB)
```bash
pnpm --filter @runacademy/api prisma:migrate
```
- 마이그레이션 이름을 명확히 입력 (`add_pdp_analysis_table` 같은 식)
- 생성된 SQL을 **반드시 검토** — 의도치 않은 DROP/ALTER 없는지

### 3. 클라이언트 재생성
```bash
pnpm --filter @runacademy/api prisma:generate
```

### 4. 타입 체크
```bash
pnpm --filter @runacademy/api typecheck
```

### 5. 영향 받는 코드 수정
- 새 필드/모델 사용처에서 타입 에러 해결
- 기존 쿼리에서 NULL/필수 변경 영향 확인

## 위험 신호 (반드시 사용자 확인)
- `DROP COLUMN` / `DROP TABLE`이 SQL에 포함됨
- NOT NULL 컬럼 추가 (기존 데이터 백필 필요)
- 인덱스 변경 (대용량 테이블이면 락 영향)
- 외래 키 cascade 변경

## 운영 DB 적용 (Vercel)
- 자동 적용 안 됨 — 별도 절차 필요
- 운영 적용 전 백업 확인
- `prisma migrate deploy`로 적용 (개발의 `dev` 아님)

## 금지
- `prisma db push` 사용 금지 (마이그레이션 파일 안 남음)
- 기존 마이그레이션 파일 수정 금지 (새 마이그레이션으로 보정)
- `--accept-data-loss` 플래그 금지 (사용자 명시 승인 시에만)
