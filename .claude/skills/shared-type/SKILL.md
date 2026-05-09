---
name: shared-type
description: Use when adding or modifying types used by both apps/web and apps/api — they must live in packages/shared, not be duplicated
---

# 공용 타입 추가 (`packages/shared`)

## 원칙
api 응답·요청 타입, 도메인 enum 등 web과 api 양쪽이 참조하는 타입은 **반드시** `packages/shared`에 둔다.
중복 정의 발견 시 즉시 통합.

## 위치
- `packages/shared/src/<domain>.ts` — 도메인별 파일
- `packages/shared/src/index.ts` — 모든 export 모음

## 추가 절차

### 1. 도메인 파일 생성/수정
```ts
// packages/shared/src/foo.ts
export interface FooRequest { ... }
export interface FooResponse { ok: boolean; data: ... }
export type FooStatus = "pending" | "done" | "failed";
```

### 2. index.ts에 re-export
```ts
// packages/shared/src/index.ts
export * from "./foo";
```

### 3. 빌드 (필요 시)
```bash
pnpm --filter @runacademy/shared build
```
대부분의 경우 tsx/tsc가 직접 참조하므로 빌드 불필요.

### 4. 양쪽 워크스페이스에서 import
```ts
import type { FooRequest, FooResponse } from "@runacademy/shared";
```

## 컨벤션
- 인터페이스는 `PascalCase`
- 유니온 타입은 리터럴 string 권장 (`"a" | "b"`)
- enum 대신 `as const` 객체 + 유니온 추출 패턴 권장
- 외부 라이브러리 타입에 의존하면 `import type`으로 격리

## 검증
- `pnpm typecheck` 전체
- web/api 양쪽에서 import가 깨지지 않는지 확인

## 안티패턴
- web과 api에 같은 인터페이스 따로 정의 ❌
- shared에 런타임 코드(클래스 인스턴스, 부수효과) 포함 ❌ — 타입과 순수 함수만
- shared가 web/api 패키지를 import ❌ (역방향 의존성)
