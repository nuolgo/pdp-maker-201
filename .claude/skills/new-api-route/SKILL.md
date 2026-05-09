---
name: new-api-route
description: Use when adding any new HTTP route to the api server. Documents the canonical pattern for registering routes in main.ts and structuring controllers.
---

# 새 API 라우트 추가 패턴

## 라우트 등록 위치
**모든 라우트는 `apps/api/src/main.ts`의 `createServer` 콜백에 등록.**
도메인별 라우터를 따로 두지 않는다 — 가시성을 위해 한 파일에 모은다.

## 단계

### 1. 컨트롤러 작성 (또는 확장)
`apps/api/src/modules/<domain>/<domain>.controller.ts`:
```ts
export class FooController {
  async create(body: FooCreateRequest): Promise<FooResponse> {
    // ...
  }
}
```

### 2. 타입 정의 (공유)
`packages/shared/src/<domain>.ts`:
```ts
export interface FooCreateRequest { ... }
export interface FooResponse { ok: boolean; ... }
```
→ `packages/shared/src/index.ts`에서 re-export

### 3. main.ts에 인스턴스 추가
```ts
const fooController = new FooController();
```

### 4. 라우트 매칭 추가
정확 매칭:
```ts
if (req.method === "POST" && pathname === "/v1/foo") {
  respondJson(res, 200, await fooController.create(await readJsonBody(req)));
  return;
}
```

파라미터 매칭:
```ts
const fooMatch = pathname.match(/^\/v1\/foo\/([^/]+)$/);
if (req.method === "GET" && fooMatch) {
  respondJson(res, 200, await fooController.getById(fooMatch[1]));
  return;
}
```

### 5. 응답 컨벤션
- 성공: 컨트롤러 반환값 그대로 `respondJson`
- 실패: throw `Error` 또는 `{ ok: false, code, message }` 반환
- 404는 main.ts 마지막 fallback이 처리

## 검증
- `pnpm --filter @runacademy/api typecheck`
- `pnpm --filter @runacademy/api dev` 실행 후 curl/브라우저로 호출

## 안티패턴
- 별도 파일에서 `server.on('request', ...)` 핸들러 추가 ❌
- 컨트롤러에서 `res` 직접 조작 ❌ (main.ts가 응답 일원화)
- 라우트별 미들웨어 체인 ❌ (필요하면 컨트롤러 메서드 안에서 처리)
